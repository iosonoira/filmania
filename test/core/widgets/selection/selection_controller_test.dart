import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/core/widgets/selection/selection_controller.dart';

void main() {
  group('SelectionController', () {
    test('starts inactive with an empty selection', () {
      final controller = SelectionController<int>();
      expect(controller.isActive, isFalse);
      expect(controller.selected, isEmpty);
    });

    test('enter() activates selection mode with exactly one item', () {
      final controller = SelectionController<int>();
      controller.enter(1);
      expect(controller.isActive, isTrue);
      expect(controller.selected, {1});
    });

    test('toggle() adds then removes an item, notifying listeners each time', () {
      final controller = SelectionController<int>();
      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.toggle(1);
      expect(controller.isSelected(1), isTrue);
      expect(notifications, 1);

      controller.toggle(1);
      expect(controller.isSelected(1), isFalse);
      expect(controller.isActive, isFalse);
      expect(notifications, 2);
    });

    test('clear() empties the selection and exits selection mode', () {
      final controller = SelectionController<int>();
      controller.enter(1);
      controller.toggle(2);
      controller.clear();
      expect(controller.isActive, isFalse);
      expect(controller.selected, isEmpty);
    });

    test('clear() on an already-empty selection does not notify', () {
      final controller = SelectionController<int>();
      var notifications = 0;
      controller.addListener(() => notifications++);
      controller.clear();
      expect(notifications, 0);
    });
  });
}
