import 'package:aurora/core/core.dart';
import 'package:aurora/core/interface.dart';
import 'package:aurora/enum/enum.dart';
import 'package:aurora/manager/core_manager.dart';
import 'package:aurora/models/models.dart';
import 'package:aurora/providers/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCoreHandlerInterface extends Mock implements CoreHandlerInterface {}

void main() {
  testWidgets('duplicate crash events disconnect the core only once', (
    tester,
  ) async {
    final coreInterface = _MockCoreHandlerInterface();
    when(() => coreInterface.stopLog()).thenAnswer((_) {});
    final controller = CoreController.test(coreInterface);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: CoreManager(controller: controller, child: const SizedBox()),
        ),
      ),
    );
    container.read(coreStatusProvider.notifier).value = CoreStatus.connected;
    final transitions = <CoreStatus>[];
    final subscription = container.listen<CoreStatus>(
      coreStatusProvider,
      (_, next) => transitions.add(next),
    );
    addTearDown(subscription.close);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

    const crash = CoreEvent(type: CoreEventType.crash, data: 'boom');
    coreEventManager.sendEvent(crash);
    coreEventManager.sendEvent(crash);
    await tester.pump();

    expect(container.read(coreStatusProvider), CoreStatus.disconnected);
    expect(transitions, [CoreStatus.disconnected]);
    verifyNever(() => coreInterface.stop());

    await tester.pumpWidget(const SizedBox());
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  });
}
