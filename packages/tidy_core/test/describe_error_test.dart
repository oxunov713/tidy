import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/tidy_core.dart';

const _strings = ErrorStrings(
  network: 'network',
  server: 'server',
  tooManyRequests: 'slow down',
  sessionExpired: 'expired',
  slotTaken: 'slot taken',
  forbidden: 'forbidden',
  notFound: 'not found',
  invalidTransition: 'invalid transition',
  wrongRole: 'wrong role',
  generic: 'generic',
);

void main() {
  String describe(Object error) => describeError(error, _strings);

  test('known failures use the app wording', () {
    expect(describe(const NetworkException()), 'network');
    expect(describe(const ServerException(message: 'boom')), 'server');
    expect(describe(const TooManyRequestsException(message: 'x')), 'slow down');
    expect(describe(const UnauthorizedException(message: 'x')), 'expired');
    expect(describe(const SlotTakenException(message: 'x')), 'slot taken');
    expect(describe(const NotFoundException(message: 'x')), 'not found');
    expect(
      describe(
        const WrongRoleException(
          expected: UserRole.client,
          actual: UserRole.cleaner,
        ),
      ),
      'wrong role',
    );
  });

  test('invalid_transition shows the status the server names', () {
    expect(
      describe(
        const InvalidTransitionException(
          message: "A completed booking can't be cancelled.",
        ),
      ),
      "A completed booking can't be cancelled.",
    );
    expect(
      describe(const InvalidTransitionException(message: '  ')),
      'invalid transition',
      reason: 'no message from the server',
    );
  });

  test('a role-mismatch 403 shows the server message', () {
    expect(
      describe(
        const ForbiddenException(
          message: 'This number is registered as a cleaner.',
        ),
      ),
      'This number is registered as a cleaner.',
    );
    expect(describe(const ForbiddenException(message: '')), 'forbidden');
  });

  test('validation errors keep the server text, it names the field', () {
    expect(
      describe(const InvalidRequestException(message: 'tip must be 0-10000')),
      'tip must be 0-10000',
    );
  });

  test('anything else is generic', () {
    expect(describe(StateError('x')), 'generic');
    expect(describe('oops'), 'generic');
  });

  test('StatusLabels maps every status', () {
    const labels = StatusLabels(
      pending: 'p',
      confirmed: 'c',
      assigned: 'a',
      onTheWay: 'o',
      inProgress: 'i',
      completed: 'd',
      cancelled: 'x',
    );
    expect(
      BookingStatus.values.map(labels.of).join(),
      'pcaoidx',
    );
  });
}
