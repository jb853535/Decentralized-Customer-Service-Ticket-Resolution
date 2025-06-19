;; Resolution Tracking Contract
;; Tracks the progress and resolution of customer service tickets

;; Constants
(define-constant err-not-found (err u300))
(define-constant err-unauthorized (err u301))
(define-constant err-invalid-resolution (err u302))

;; Data Maps
(define-map ticket-resolutions
  { ticket-id: uint }
  {
    provider-id: uint,
    resolution-notes: (string-ascii 500),
    resolution-time: uint,
    time-to-resolve: uint, ;; in minutes
    resolution-type: (string-ascii 30) ;; "solved", "workaround", "escalated", "closed"
  }
)

(define-map resolution-updates
  { ticket-id: uint, update-id: uint }
  {
    provider-id: uint,
    update-notes: (string-ascii 300),
    timestamp: uint,
    progress-percentage: uint
  }
)

(define-map ticket-update-count
  { ticket-id: uint }
  { count: uint }
)

;; Public Functions

;; Add resolution update
(define-public (add-resolution-update
  (ticket-id uint)
  (update-notes (string-ascii 300))
  (progress-percentage uint))
  (let ((current-time (unwrap-panic (get-block-info? time u0)))
        (update-count (default-to u0 (get count (map-get? ticket-update-count { ticket-id: ticket-id }))))
        (new-update-id (+ update-count u1)))
    ;; In real implementation, verify provider is assigned to ticket
    (map-set resolution-updates
      { ticket-id: ticket-id, update-id: new-update-id }
      {
        provider-id: u1, ;; Would get from ticket assignment
        update-notes: update-notes,
        timestamp: current-time,
        progress-percentage: progress-percentage
      }
    )
    (map-set ticket-update-count
      { ticket-id: ticket-id }
      { count: new-update-id }
    )
    (ok new-update-id)
  )
)

;; Mark ticket as resolved
(define-public (resolve-ticket
  (ticket-id uint)
  (resolution-notes (string-ascii 500))
  (resolution-type (string-ascii 30))
  (created-at uint))
  (let ((current-time (unwrap-panic (get-block-info? time u0)))
        (time-to-resolve (- current-time created-at)))
    ;; In real implementation, verify provider is assigned to ticket
    (map-set ticket-resolutions
      { ticket-id: ticket-id }
      {
        provider-id: u1, ;; Would get from ticket assignment
        resolution-notes: resolution-notes,
        resolution-time: current-time,
        time-to-resolve: time-to-resolve,
        resolution-type: resolution-type
      }
    )
    (ok true)
  )
)

;; Read-only Functions

;; Get ticket resolution
(define-read-only (get-ticket-resolution (ticket-id uint))
  (map-get? ticket-resolutions { ticket-id: ticket-id })
)

;; Get resolution update
(define-read-only (get-resolution-update (ticket-id uint) (update-id uint))
  (map-get? resolution-updates { ticket-id: ticket-id, update-id: update-id })
)

;; Get update count for ticket
(define-read-only (get-update-count (ticket-id uint))
  (default-to u0 (get count (map-get? ticket-update-count { ticket-id: ticket-id })))
)

;; Calculate average resolution time (simplified)
(define-read-only (get-provider-avg-resolution-time (provider-id uint))
  ;; In real implementation, this would aggregate across all resolved tickets
  (ok u60) ;; placeholder: 60 minutes
)
