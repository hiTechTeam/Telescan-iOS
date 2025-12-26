# Security Policy

## Supported versions

We actively support the following versions with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Vulnerability message

We take safety seriously. If you discover a security vulnerability in Telescan, please help us by reporting it responsibly.

### How to report

**Please DO NOT report security vulnerabilities via GitHub public releases.**

Instead, report security vulnerabilities by email:

- **Email**: r66cha@gmail.com

Include the following information in your report:

- Clear description of the vulnerability
- Steps to reproduce the problem
- Potential impact and severity
- Any proposed fixes or mitigations.

### What to expect

- **Confirmation**: We will confirm receipt of your report within 48 hours.
- **Investigation**: We will study and verify the vulnerability.
- **Updates**: We will provide regular updates on our progress (at least weekly).
- **Resolution**: We will work to resolve confirmed vulnerabilities within a reasonable time frame.
- **Disclosure**: We will confirm the disclosure with you after corrections are made.

## Security measures

### Data protection

- **Encryption**: All network connections use TLS 1.3.
- **Hashing**: authentication codes are hashed using the [SHA-256](https://en.wikipedia.org/wiki/SHA-2) protocol.
- **No plaintext storage**: Sensitive data is never stored in plaintext.

### Bluetooth Security

- **Service UUID**: Uses standard BLE advertising with a custom service UUID (FFF0).
- **No GATT services**: Pure ad-based discovery, no BLE communication.
- **Manage timeouts**: Automatically clear outdated device connections.
- **Permission Based**: Requires explicit user permission to access Bluetooth.

### API Security

- **HTTPS Only**: All API endpoints require secure connections.
- **Rate Limiting**: The backend implements a rate limit to prevent abuse.
- **Validation of input data**: All input data is checked and processed.
- **Minimum Data**: The API returns only the required profile information.

### Client Security

- **Code Signing**: The iOS app is signed with Apple code.
- **App Store Review**: All releases undergo Apple security review.
- **No third party analytics**: Tracking and analytics libraries are not included.
- **Minimum permissions**: Only required iOS permissions (Bluetooth, network) are requested.

## Known security considerations

### Bluetooth limitations

- BLE signals can be intercepted in close proximity (within ~30 meters)
- The distance estimate based on RSSI is approximate and can be manipulated.
- No end-to-end encryption for profile data transfer (depends on HTTPS)

### Authentication Design

- Code-based authentication is vulnerable to [shoulder surfing](https://en.wikipedia.org/wiki/Shoulder_surfing)
- Hashed codes prevent replay attacks, but do not provide mutual authentication.
- Telegram integration is based on the Telegram security model.

## Security guidelines for users

###Using the app

- Turn on scanning only when you want to be detected.
- Be careful when disclosing personal information.
- Update your code if it is stolen in [@tgtelescan_bot](https://t.me/tgtelescan_bot) and then the previous code will become invalid and the attacker will not be able to broadcast your profile.

### Network Security

- Use reliable Wi-Fi networks.
- Avoid using the application on jailbroken devices.
- Keep the Telegram application up to date and secure.

## Responsible Disclosure

We ask you:

- Give us a reasonable time to correct problems before they are publicly disclosed.
- Avoid accessing or changing user data without permission.
- Do not perform denial of service attacks or degrade service quality.
- Respect user privacy and do not collect data for malicious purposes.

## Contact

For questions or concerns regarding security:

- **General support**: r66cha@gmail.com

## Recognition

We value the security researchers who help keep Telescan secure. With your permission, we may publicly recognize your contributions to our safety.

---

_This Security Policy is part of the Telescan project and is governed by the [MIT License](./LICENSE)._
