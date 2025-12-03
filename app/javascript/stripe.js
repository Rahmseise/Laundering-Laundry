// app/javascript/stripe.js
document.addEventListener('turbo:load', function() {
  const paymentForm = document.getElementById('payment-form');

  if (!paymentForm) return; // Exit if not on checkout page

  // Wait for Stripe to load
  const initStripe = () => {
    if (typeof Stripe === 'undefined') {
      setTimeout(initStripe, 50);
      return;
    }

    const publishableKey = paymentForm.dataset.stripeKey;
    const stripe = Stripe(publishableKey);
    const elements = stripe.elements();

    const cardElement = elements.create('card', {
      style: {
        base: {
          fontSize: '16px',
          color: '#32325d',
          fontFamily: 'system-ui, sans-serif',
          '::placeholder': { color: '#aab7c4' }
        },
        invalid: {
          color: '#fa755a',
          iconColor: '#fa755a'
        }
      }
    });

    cardElement.mount('#card-element');

    // Handle errors
    cardElement.on('change', (event) => {
      const errorDiv = document.getElementById('card-errors');
      errorDiv.textContent = event.error ? event.error.message : '';
    });

    // Handle form submit
    paymentForm.addEventListener('submit', async (e) => {
      e.preventDefault();

      const submitBtn = document.getElementById('submit-button');
      submitBtn.disabled = true;
      submitBtn.textContent = 'Processing...';

      const {token, error} = await stripe.createToken(cardElement);

      if (error) {
        document.getElementById('card-errors').textContent = error.message;
        submitBtn.disabled = false;
        submitBtn.textContent = 'Place Order';
      } else {
        // Add token to form
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'stripeToken';
        input.value = token.id;
        paymentForm.appendChild(input);

        // Submit form
        paymentForm.submit();
      }
    });
  };

  initStripe();
});