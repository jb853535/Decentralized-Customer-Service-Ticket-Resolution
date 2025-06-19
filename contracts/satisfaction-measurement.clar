;; Satisfaction Measurement Contract
;; Measures and tracks customer satisfaction with service resolution

;; Constants
(define-constant err-not-found (err u500))
(define-constant err-unauthorized (err u501))
(define-constant err-already-rated (err u502))
(define-constant err-invalid-rating (err u503))

;; Data Maps
(define-map satisfaction-ratings
  { ticket-id: uint }
  {
    customer: principal,
    provider-id: uint,
    rating: uint, ;; 1-5 scale
    feedback: (string-ascii 300),
    rated-at: uint,
    resolution-quality: uint, ;; 1-5 scale
    response-time-rating: uint, ;; 1-5 scale
    communication-rating: uint ;; 1-5 scale
  }
)

(define-map provider-satisfaction-stats
  { provider-id: uint }
  {
    total-ratings: uint,
    average-rating: uint,
    total-score: uint,
    five-star-count: uint,
    four-star-count: uint,
    three-star-count: uint,
    two-star-count: uint,
    one-star-count: uint
  }
)

(define-map satisfaction-surveys
  { survey-id: uint }
  {
    ticket-id: uint,
    customer: principal,
    sent-at: uint,
    completed: bool,
    reminder-count: uint
  }
)

(define-data-var next-survey-id uint u1)

;; Public Functions

;; Submit satisfaction rating
(define-public (submit-satisfaction-rating
  (ticket-id uint)
  (provider-id uint)
  (rating uint)
  (feedback (string-ascii 300))
  (resolution-quality uint)
  (response-time-rating uint)
  (communication-rating uint))
  (let ((current-time (unwrap-panic (get-block-info? time u0))))
    ;; Validate rating is between 1-5
    (asserts! (and (>= rating u1) (<= rating u5)) err-invalid-rating)
    (asserts! (and (>= resolution-quality u1) (<= resolution-quality u5)) err-invalid-rating)
    (asserts! (and (>= response-time-rating u1) (<= response-time-rating u5)) err-invalid-rating)
    (asserts! (and (>= communication-rating u1) (<= communication-rating u5)) err-invalid-rating)

    ;; Check if already rated
    (asserts! (is-none (map-get? satisfaction-ratings { ticket-id: ticket-id })) err-already-rated)

    ;; Store the rating
    (map-set satisfaction-ratings
      { ticket-id: ticket-id }
      {
        customer: tx-sender,
        provider-id: provider-id,
        rating: rating,
        feedback: feedback,
        rated-at: current-time,
        resolution-quality: resolution-quality,
        response-time-rating: response-time-rating,
        communication-rating: communication-rating
      }
    )

    ;; Update provider stats
    (update-provider-stats provider-id rating)
  )
)

;; Update provider satisfaction statistics
(define-private (update-provider-stats (provider-id uint) (new-rating uint))
  (let ((current-stats (default-to
    { total-ratings: u0, average-rating: u0, total-score: u0,
      five-star-count: u0, four-star-count: u0, three-star-count: u0,
      two-star-count: u0, one-star-count: u0 }
    (map-get? provider-satisfaction-stats { provider-id: provider-id }))))
    (let ((new-total-ratings (+ (get total-ratings current-stats) u1))
          (new-total-score (+ (get total-score current-stats) new-rating))
          (new-average (/ new-total-score new-total-ratings)))
      (map-set provider-satisfaction-stats
        { provider-id: provider-id }
        (merge current-stats {
          total-ratings: new-total-ratings,
          total-score: new-total-score,
          average-rating: new-average,
          five-star-count: (if (is-eq new-rating u5) (+ (get five-star-count current-stats) u1) (get five-star-count current-stats)),
          four-star-count: (if (is-eq new-rating u4) (+ (get four-star-count current-stats) u1) (get four-star-count current-stats)),
          three-star-count: (if (is-eq new-rating u3) (+ (get three-star-count current-stats) u1) (get three-star-count current-stats)),
          two-star-count: (if (is-eq new-rating u2) (+ (get two-star-count current-stats) u1) (get two-star-count current-stats)),
          one-star-count: (if (is-eq new-rating u1) (+ (get one-star-count current-stats) u1) (get one-star-count current-stats))
        })
      )
      (ok true)
    )
  )
)

;; Create satisfaction survey
(define-public (create-satisfaction-survey (ticket-id uint))
  (let ((survey-id (var-get next-survey-id))
        (current-time (unwrap-panic (get-block-info? time u0))))
    (map-set satisfaction-surveys
      { survey-id: survey-id }
      {
        ticket-id: ticket-id,
        customer: tx-sender,
        sent-at: current-time,
        completed: false,
        reminder-count: u0
      }
    )
    (var-set next-survey-id (+ survey-id u1))
    (ok survey-id)
  )
)

;; Read-only Functions

;; Get satisfaction rating for ticket
(define-read-only (get-satisfaction-rating (ticket-id uint))
  (map-get? satisfaction-ratings { ticket-id: ticket-id })
)

;; Get provider satisfaction statistics
(define-read-only (get-provider-satisfaction-stats (provider-id uint))
  (map-get? provider-satisfaction-stats { provider-id: provider-id })
)

;; Get satisfaction survey
(define-read-only (get-satisfaction-survey (survey-id uint))
  (map-get? satisfaction-surveys { survey-id: survey-id })
)

;; Calculate provider satisfaction percentage
(define-read-only (get-provider-satisfaction-percentage (provider-id uint))
  (match (map-get? provider-satisfaction-stats { provider-id: provider-id })
    stats
    (let ((total-ratings (get total-ratings stats)))
      (if (> total-ratings u0)
        (/ (* (get average-rating stats) u100) u5) ;; Convert to percentage
        u0
      )
    )
    u0
  )
)
