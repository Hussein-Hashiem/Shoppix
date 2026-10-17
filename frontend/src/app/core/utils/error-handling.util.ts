import { HttpErrorResponse } from "@angular/common/http";
import { ApiErrorModel } from "../models/api-error.model";

export function getApiErrorMessages(err: HttpErrorResponse): { errors: string[], status: number } {
  const apiError = err.error as ApiErrorModel | null;
  const hasErrors = !!apiError?.errors && Object.keys(apiError.errors).length > 0;
  if (hasErrors) {
    const flatErrors = Object.values(apiError.errors).flat();
    if (flatErrors.length > 0) {
      return {
        errors: flatErrors,
        status: apiError.status ?? err.status ?? 500
      };
    }
  }
    return {
      errors: ["Unexpected error occured, please try again"],
      status: err.status || 500
    };
}
