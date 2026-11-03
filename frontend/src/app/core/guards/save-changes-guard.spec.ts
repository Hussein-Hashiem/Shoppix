import { TestBed } from '@angular/core/testing';
import { CanDeactivateFn } from '@angular/router';
import { saveChangesGuard } from './save-changes-guard';

describe('saveChangesGuard', () => {
  const executeGuard: CanDeactivateFn<unknown> = (...guardParameters) =>
    TestBed.runInInjectionContext(() => saveChangesGuard(...guardParameters));

  beforeEach(() => {
    TestBed.configureTestingModule({});
  });

  it('should be created', () => {
    expect(executeGuard).toBeTruthy();
  });
});
