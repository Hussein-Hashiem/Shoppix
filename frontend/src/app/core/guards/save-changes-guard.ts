import { CanDeactivateFn } from '@angular/router';
import { Observable } from 'rxjs';

export  interface canDeactivateComponent {
  canDeactivate : () => Observable<boolean>| boolean; 
}

export const saveChangesGuard: CanDeactivateFn<canDeactivateComponent> = (
  component,
  currentRoute,
  currentState,
  nextState,
) => {
  return component.canDeactivate ? component.canDeactivate() : true;
};
