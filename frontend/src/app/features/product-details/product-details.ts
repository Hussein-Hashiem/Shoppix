import { Component, computed, effect, inject, input, numberAttribute, output, signal, DestroyRef, OnInit } from '@angular/core';
import { ProductDetailsService } from '../../core/services/product-details.service';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { HotToastService } from '@ngxpert/hot-toast';
import { LucideHouse, LucideMinus, LucidePlus, LucideShoppingCartPlus, LucideWifiOff, LucideServerOff, LucideRefreshCw, LucideTriangleAlert, LucideInbox } from '@lucide/angular';
import { CartService } from '../../core/services/cart.service';
import { ProductModel } from '../../core/models/product.model';
import { ProductCard } from '../../shared/components/product-card/product-card';
import { HttpErrorResponse } from '@angular/common/http';
import { getApiErrorMessages } from '../../core/utils/error-handling.util';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ErrorState } from '../../core/models/api-error.model';

@Component({
  imports: [RouterLink, ProductCard, LucideHouse, LucideShoppingCartPlus, LucidePlus, LucideMinus, LucideInbox, LucideWifiOff, LucideServerOff, LucideRefreshCw, LucideTriangleAlert],
  selector: 'app-product-details',
  styleUrl: './product-details.css',
  templateUrl: './product-details.html',
})
export class ProductDetails implements OnInit {
  // Injections
  productDetailsService = inject(ProductDetailsService);
  cartService = inject(CartService);
  toast = inject(HotToastService);
  route = inject(ActivatedRoute);
  destroyRef = inject(DestroyRef);

  id = input.required({ transform: numberAttribute });
  prodDetails = signal<ProductModel | null>(null);
  relatedProds = signal<ProductModel[]>([]);
  isLoading = signal<boolean>(true);
  hasError = signal<boolean>(false);
  amount = signal<number>(1);
  AddToCart = output<boolean>();

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
      case 'NOT_FOUND':
        return {
          title: 'Product Not Found',
          description: 'The product you are looking for might have been removed or does not exist.',
          tone: 'emerald',
          icon: 'inbox'
        };
      default:
        return {
          title: 'Something went wrong',
          description: this.errorMessage() || 'We could not load the product details right now.',
          tone: 'gray',
          icon: 'warning'
        };
    }
  });

  ngOnInit(): void {
    this.route.params
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe(() => {
        const productId = this.id();
        if (productId) {
          this.loadProduct(productId);
        }
      })
  }

  loadProduct(id: number | string) {
    this.hasError.set(false);
    this.state.set('');
    this.isLoading.set(true);
    this.amount.set(1);

    this.productDetailsService.getProductById(id).subscribe({
      next: (prod) => {
        this.prodDetails.set(prod);
        this.isLoading.set(false);
        this.loadRelated(id);
      },
      error: (err) => {
        this.handleError(err);
      }
    })
  }

  loadRelated(id: number | string) {
    this.productDetailsService.getRelatedProducts(id).subscribe({
      next: (prods) => {
        this.relatedProds.set(prods);
      },
      error: (err) => {
        console.error('Error loading related products:', err);
      }
    })
  }

  private handleError(err: HttpErrorResponse) {
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

  isOutOfStock = computed(() => {
    const product = this.prodDetails();
    if (!product) return true;

    const cartItem = this.cartService.cartItems().find(item => item.id === product.id);
    const currentQuantityInCart = cartItem ? cartItem.quantity : 0;
    return currentQuantityInCart >= product.stockQuantity;
  });

  onAddToCart() {
    const product = this.prodDetails();
    if (!product) return;

    const isSuccess = this.cartService.addToCart(product, this.amount());
    this.AddToCart.emit(isSuccess);

    if (isSuccess) {
      this.toast.success('Product added to cart successfully!');
    } else {
      this.toast.error('Failed to add product to cart. Stock limit reached.');
    }
  }

  changeAmount(am: number) {
    this.amount.update((crAm) => {
      const newAmount = crAm + am;
      return newAmount > 0 ? newAmount : 1;
    })
  }

  productCartQuantity = computed(() => {
    const currentProd = this.prodDetails();
    if (!currentProd) return 0;

    const item = this.cartService.cartItems().find((item) => item.id === currentProd.id);
    return item ? item.quantity : 0;
  });

  addToCart(isSuccess: boolean): void {
    if (isSuccess) {
      this.toast.success('Product added to cart successfully!');
    } else {
      this.toast.error('Failed to add product to cart. Stock limit reached.');
    }
  }
}
