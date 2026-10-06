import Swal from 'sweetalert2';

export const ConfirmSwal = Swal.mixin({
  width: 340,
  padding: '1.25rem',
  buttonsStyling: false,
  reverseButtons: true,
  showCancelButton: true,
  focusCancel: true,
  customClass: {
    popup: '!rounded-2xl !border !border-slate-100 !bg-white !shadow-xl',
    icon: '!mt-1 !mb-2 !h-14 !w-14 !text-[0.65rem]',
    title: '!p-0 !text-base !font-bold !text-slate-900',
    htmlContainer: '!m-0 !mt-1 !p-0 !text-sm !text-slate-500',
    actions: '!mt-5 !gap-2 !w-full',
    confirmButton:
      '!flex-1 cursor-pointer rounded-xl bg-rose-600 px-4 py-2.5 text-sm font-semibold text-white transition-all hover:bg-rose-700 active:scale-[0.98]',
    cancelButton:
      '!flex-1 cursor-pointer rounded-xl border border-slate-200 bg-white px-4 py-2.5 text-sm font-semibological text-slate-700 transition-all hover:bg-slate-50 active:scale-[0.98]',
  },
});