import { ProductCard } from './../../shared/components/product-card/product-card';
import { Component, computed, DestroyRef, inject, OnInit, signal } from '@angular/core';
import { ProductModel } from '../../core/models/product.model';
import { LucideMoveRight, LucideWifiOff, LucideServerOff, LucideRefreshCw, LucideTriangleAlert, LucideInbox } from '@lucide/angular';
import { CommonModule } from '@angular/common';
import { ProductCardSkeleton } from '../../shared/components/product-card-skeleton/product-card-skeleton';
import { ProductsService } from '../../core/services/products.service';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { HotToastService } from '@ngxpert/hot-toast';
import { HttpErrorResponse } from '@angular/common/http';
import { getApiErrorMessages } from '../../core/utils/error-handling.util';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ErrorState } from '../../core/models/api-error.model';

@Component({
  imports: [CommonModule, LucideWifiOff, LucideServerOff, LucideRefreshCw, LucideTriangleAlert, LucideMoveRight, ProductCard, ProductCardSkeleton, LucideInbox],
  selector: 'app-home',
  styleUrl: './home.css',
  templateUrl: './home.html',
})
export class Home implements OnInit {
  math = Math;
  // Injections
  productsService = inject(ProductsService);
  router = inject(Router);
  route = inject(ActivatedRoute);
  toast = inject(HotToastService);
  destroyRef = inject(DestroyRef);


  allproducts = signal<ProductModel[]>([]);
  currentProducts = signal<ProductModel[]>([]);
  isLoading = signal<boolean>(true);
  hasError = signal<boolean>(false);

  // pagination varibales
  currentPage = signal<number>(1);
  totalPages = signal<number>(1);
  pageSize: number = 12;

  // handel expected errors
  errorMessage = signal<string>('');
  state = signal<ErrorState>('');
  errorView = computed(() => {
    switch (this.state()) {
      case 'OFFLINE':
        return {
          title: "You're offline",
          description: 'Check your Wi-Fi or mobile data, then try again.',
          tone: 'amber',
          icon: 'offline'
        };
      case 'SERVER':
        return {
          title: 'Server is having trouble',
          description: 'Something went wrong on our side. Please try again in a moment.',
          tone: 'red',
          icon: 'server'
        };
      default:
        return {
          title: 'Something went wrong',
          description: this.errorMessage() || 'We could not load the products right now.',
          tone: 'gray',
          icon: 'warning'
        };
    }
  });




  ngOnInit() {
    this.loadProducts();
    this.route.queryParams
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe((params) => this.handlePageParam(params));
  }

  loadProducts() {
    this.hasError.set(false);
    this.state.set('');
    this.isLoading.set(true);
    this.productsService.getProducts().subscribe({
      next: (products) => {
        this.allproducts.set(products);
        this.isLoading.set(false);
        this.totalPages.set(this.getPagesCount(products.length));
        this.handlePageParam(this.route.snapshot.queryParams);
      },
      error: (err: HttpErrorResponse) => {
        const { errors, status } = getApiErrorMessages(err);
        if (status === 0 || status === 408) {
          this.state.set('OFFLINE');
        } else if (status === 500) {
          this.state.set('SERVER');
        }
        this.errorMessage.set(errors.join('\n'));
        this.isLoading.set(false);
        this.hasError.set(true);
      }
    });
  }
  handlePageParam(params: Params) {
    if (this.allproducts().length === 0) return;
    const queryPage = parseInt(params['page']);
    let page = 1;
    if (!isNaN(queryPage) && queryPage > 0) {
      page = Math.min(queryPage, this.totalPages());
    }
    if (params['page'] !== undefined && queryPage !== page) {
      this.router.navigate([], {
        relativeTo: this.route,
        queryParams: { page },
        queryParamsHandling: 'merge',
        replaceUrl: true
      })
      return;
    }
    this.updateProductsView(page);
  }


  getPagesCount(productNumber: number): number {
    return Math.ceil(productNumber / this.pageSize);
  }

  updateProductsView(page: number): void {
    if (this.totalPages() < page)
      return;
    this.currentPage.set(page);
    const startIndex = (page - 1) * this.pageSize;
    const endIndex = startIndex + this.pageSize;
    this.currentProducts.set(this.allproducts().slice(startIndex, endIndex));
  }

  updateCurrentProducts(page: number): void {
    this.router.navigate([], {
      relativeTo: this.route,
      queryParams: { page: page },
      queryParamsHandling: 'merge'
    })
  }

  getPaginationNumbers(): (number | string)[] {
    const totalPages = this.totalPages();
    const currentPage = this.currentPage();

    if (totalPages <= 5) {
      return Array.from({ length: totalPages }, (_, i) => i + 1);
    }

    const pages: (number | string)[] = [];

    if (currentPage < 3) {
      pages.push(1, 2, 3, '...', totalPages);
    } else if (currentPage > totalPages - 2) {
      pages.push(1, '...', totalPages - 2, totalPages - 1, totalPages);
    } else {
      pages.push(1, '...', currentPage - 1, currentPage, currentPage + 1, '...', totalPages);
    }
    return pages;
  }

  addToCart(isSuccess: boolean): void {
    if (isSuccess) {
      this.toast.success('Product added to cart successfully!');
    } else {
      this.toast.error('Failed to add product to cart. Stock limit reached.');
    }
  }
}
