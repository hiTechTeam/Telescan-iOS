# Security Policy

## Supported Versions

We actively support the following versions with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability in Telescan, please help us by reporting it responsibly.

### How to Report

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report security vulnerabilities by emailing:

- **Email**: security@telescan.app
- **PGP Key**: [Link to PGP key if available]

Include the following information in your report:

- A clear description of the vulnerability
- Steps to reproduce the issue
- Potential impact and severity
- Any suggested fixes or mitigations

### What to Expect

- **Acknowledgment**: We will acknowledge receipt of your report within 48 hours
- **Investigation**: We will investigate and validate the vulnerability
- **Updates**: We will provide regular updates on our progress (at least weekly)
- **Resolution**: We will work to resolve validated vulnerabilities within a reasonable timeframe
- **Disclosure**: We will coordinate disclosure with you after fixes are implemented

## Security Measures

### Data Protection

- **Encryption**: All network communications use TLS 1.3
- **Hashing**: Authentication codes are SHA256 hashed
- **No Plaintext Storage**: Sensitive data is never stored in plaintext
- **Ephemeral Keys**: No long-term cryptographic keys stored

### Bluetooth Security

- **Service UUID**: Uses standard BLE advertising with custom service UUID (FFF0)
- **No GATT Services**: Pure advertising-based discovery, no data exchange over BLE
- **Timeout Management**: Automatic cleanup of stale device connections
- **Permission-Based**: Requires explicit user permission for Bluetooth access

### API Security

- **HTTPS Only**: All API endpoints require secure connections
- **Rate Limiting**: Backend implements rate limiting to prevent abuse
- **Input Validation**: All inputs are validated and sanitized
- **Minimal Data**: API returns only necessary profile information

### Client Security

- **Code Signing**: iOS app is code-signed by Apple
- **App Store Review**: All releases go through Apple's security review
- **No Third-Party Analytics**: No tracking or analytics libraries included
- **Minimal Permissions**: Only requests necessary iOS permissions (Bluetooth, Network)

## Known Security Considerations

### Bluetooth Limitations

- BLE signals can be intercepted in proximity (within ~30 meters)
- RSSI-based distance estimation is approximate and can be manipulated
- No end-to-end encryption for profile data transmission (relies on HTTPS)

### Authentication Design

- Code-based authentication is vulnerable to shoulder-surfing
- Hashed codes prevent replay attacks but don't provide mutual authentication
- Telegram integration relies on Telegram's security model

### Privacy vs Security Trade-offs

- Ephemeral connections reduce data retention but limit accountability
- No logging means forensic analysis is impossible in case of abuse
- Decentralized discovery makes centralized monitoring difficult

## Security Best Practices for Users

### Device Security

- Keep your device updated with the latest iOS version
- Use a strong device passcode
- Enable Find My iPhone for remote wipe capability

### App Usage

- Only enable scanning when you want to be discoverable
- Be cautious about sharing personal information
- Report suspicious behavior to support

### Network Security

- Use trusted Wi-Fi networks
- Avoid using the app on compromised devices
- Keep Telegram app updated and secure

## Responsible Disclosure

We kindly ask that you:

- Give us reasonable time to fix issues before public disclosure
- Avoid accessing or modifying user data without permission
- Do not perform denial-of-service attacks or degrade service quality
- Respect user privacy and do not collect data for malicious purposes

## Contact

For security-related questions or concerns:

- **Security Team**: security@telescan.app
- **General Support**: support@telescan.app
- **PGP Fingerprint**: [Add if available]

## Recognition

We appreciate security researchers who help keep Telescan safe. With your permission, we may publicly acknowledge your contribution to our security.

---

_This Security Policy is part of the Telescan project and is governed by The [MIT License](./LICENSE)._
