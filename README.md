# Decentralized Customer Service Ticket Resolution System

A blockchain-based customer service platform built on Stacks using Clarity smart contracts. This system enables decentralized ticket management, provider verification, automated routing, resolution tracking, escalation management, and satisfaction measurement.

## 🌟 Features

### Core Components

1. **Service Provider Verification** (`service-provider-verification.clar`)
    - Provider registration and verification
    - Reputation scoring system
    - Specialization tracking

2. **Ticket Routing** (`ticket-routing.clar`)
    - Automated ticket creation and assignment
    - Priority-based routing
    - Status tracking

3. **Resolution Tracking** (`resolution-tracking.clar`)
    - Progress updates and notes
    - Resolution time tracking
    - Multiple resolution types

4. **Escalation Management** (`escalation-management.clar`)
    - Automatic escalation based on time thresholds
    - Manual escalation capabilities
    - Multi-level escalation system

5. **Satisfaction Measurement** (`satisfaction-measurement.clar`)
    - Customer feedback collection
    - Provider performance metrics
    - Satisfaction surveys

## 🚀 Getting Started

### Prerequisites

- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm (for testing)

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd decentralized-customer-service
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

## 📋 Usage

### For Service Providers

1. **Register as a Provider**:
   \`\`\`clarity
   (contract-call? .service-provider-verification register-provider "Tech Support Co" "Technical")
   \`\`\`

2. **Get Verified**: Wait for contract owner verification

3. **Accept Ticket Assignments**: Receive tickets based on specialization

### For Customers

1. **Create a Ticket**:
   \`\`\`clarity
   (contract-call? .ticket-routing create-ticket "Login Issue" "Cannot access my account" "Authentication" u2)
   \`\`\`

2. **Track Progress**: Monitor resolution updates

3. **Provide Feedback**: Rate service quality after resolution

### For Administrators

1. **Verify Providers**:
   \`\`\`clarity
   (contract-call? .service-provider-verification verify-provider u1)
   \`\`\`

2. **Manage Escalations**: Configure escalation rules and thresholds

## 🏗️ Architecture

### Smart Contract Structure

\`\`\`
contracts/
├── service-provider-verification.clar  # Provider management
├── ticket-routing.clar                 # Ticket lifecycle
├── resolution-tracking.clar            # Progress tracking
├── escalation-management.clar          # Escalation logic
└── satisfaction-measurement.clar       # Feedback system
\`\`\`

### Data Flow

1. **Provider Registration** → Verification → Active Status
2. **Ticket Creation** → Routing → Assignment → Resolution
3. **Progress Updates** → Escalation (if needed) → Completion
4. **Satisfaction Survey** → Rating → Provider Stats Update

## 🔧 Configuration

### Escalation Thresholds

- **Low Priority**: 8 hours (480 minutes)
- **Medium Priority**: 4 hours (240 minutes)
- **High Priority**: 2 hours (120 minutes)
- **Urgent Priority**: 1 hour (60 minutes)

### Rating System

- **Scale**: 1-5 stars
- **Categories**: Overall, Resolution Quality, Response Time, Communication
- **Provider Stats**: Automatic calculation of averages and distributions

## 🧪 Testing

The system includes comprehensive tests using Vitest:

\`\`\`bash
npm test                    # Run all tests
npm run test:watch         # Watch mode
npm run test:coverage      # Coverage report
\`\`\`

### Test Coverage

- Provider registration and verification
- Ticket creation and routing
- Resolution tracking and updates
- Escalation triggers and management
- Satisfaction rating submission

## 🔒 Security Features

- **Access Control**: Role-based permissions for different functions
- **Data Validation**: Input validation for all user-submitted data
- **State Management**: Consistent state updates across contracts
- **Error Handling**: Comprehensive error codes and messages

## 📊 Metrics and Analytics

### Provider Metrics
- Average resolution time
- Customer satisfaction scores
- Ticket completion rates
- Escalation frequency

### System Metrics
- Total tickets processed
- Average satisfaction scores
- Escalation rates by priority
- Provider performance rankings

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

## 🗺️ Roadmap

- [ ] Integration with external notification systems
- [ ] Advanced analytics dashboard
- [ ] Multi-language support
- [ ] Mobile app integration
- [ ] AI-powered ticket routing
- [ ] Blockchain-based payments for services
