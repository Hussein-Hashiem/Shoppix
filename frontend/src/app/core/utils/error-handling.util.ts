import { HttpErrorResponse } from "@angular/common/http";
import { ApiErrorModel } from "../models/api-error.model";

export const offlineError = () =>
  ErrorResponse(0, 'OFFLINE', 'network.noconnection', 'No Internet, Please Check Your Connection');

export const timeoutError = () =>
  ErrorResponse(408, 'TimeOut', 'network.timeOut', 'The request timed out. Please try again');

export const unauthorizedError = () =>
  ErrorResponse(401, 'Unauthorized', 'auth.unauthorized', 'Please login first');

export function ErrorResponse(
  status: number,
  title: string,
  key: string,
  message: string
): HttpErrorResponse {
  const body: ApiErrorModel = {
    title,
    status,
    errors: { [key]: [message] }
  };
  return new HttpErrorResponse({ status, error: body });
}


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
