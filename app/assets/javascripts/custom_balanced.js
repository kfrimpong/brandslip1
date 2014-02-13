$(document).ready(function(){
   function cardCallbackHandler(response) {
     switch (response.status) {
       case 201:
           console.log(response.data);
           var $form = $("#customer-card");
           // the uri is an opaque token referencing the tokenized card
           var cardTokenURI = response.data['uri'];
           // append the token as a hidden field to submit to the server
           $('<input>').attr({
              type: 'hidden',
              value: cardTokenURI,
              name: 'balancedCreditCardURI'
           }).appendTo($form);
           $form.find('#cc-number').val('');
         $form.find('#cc-em').val('');
         $form.find('#cc-ey').val('');
         $form.submit();

           break;
       case 400:
           // missing field - check response.error for details
           console.log(response.error);
           alert('There was an error adding your payment information:' + response.error.card_number + response.error.expiration)
           break;
       case 402:
           // we couldn't authorize the buyer's credit card
           // check response.error for details
           console.log(response.error);
           alert('There was an error adding your payment information:' + response.error.card_number + response.error.expiration)
           break
       case 404:
           // your marketplace URI is incorrect
           console.log(response.error);
           alert('There was an error adding your payment information:' + response.error.card_number + response.error.expiration)
           break;
       case 500:
           // Balanced did something bad, please retry the request
           alert('There was an error adding your payment information:' + response.error.card_number + response.error.expiration)
           break;
     }
  }

  function baCallbackHandler(response) {
     switch (response.status) {
     case 201:
         // WOO HOO! MONEY!
         // response.data.uri == URI of the bank account resource you
         // should store this bank account URI to later credit it
         console.log(response.data);
         var $form = $("#customer-bank-account");
         // the uri is an opaque token referencing the tokenized bank account
         var bank_account_uri = response.data['uri'];
         // append the token as a hidden field to submit to the server
         $('<input>').attr({
            type: 'hidden',
            value: bank_account_uri,
            name: 'balancedBankAccountURI'
         }).appendTo($form);
        $form.find('#ba-name').val('');
      $form.find('#ba-an').val('');
      $form.find('#ba-rn').val('');
      $form.submit();
         
         break;
     case 400:
         // missing field - check response.error for details
         console.log(response.error);
         alert('There was an error adding your payment information:');
         break;
     case 402:
         // we couldn't authorize the buyer's credit card
         // check response.error for details
         console.log(response.error);
         alert('There was an error adding your payment information:');
         break
     case 404:
         // your marketplace URI is incorrect
         console.log(response.error);
         alert('There was an error adding your payment information:');
         break;
     case 500:
      alert('There was an error adding your payment information:');
         // Balanced did something bad, please retry the request
         break;
   }
}

  $('#add_card').on('click', function(e){
    e.preventDefault();
    var $form = $('#customer-card');

    var creditCardData = {
       card_number: $form.find('#cc-number').val(),
       expiration_month: $form.find('#cc-em').val(),
       expiration_year: $form.find('#cc-ey').val(),
    };

    balanced.card.create(creditCardData, cardCallbackHandler);


  })

  $('#add_bank_account').on('click', function(e){
    e.preventDefault();
    var $form = $('#customer-bank-account');

    var bankAccountData = {
       name: $form.find('#ba-name').val(),
       account_number: $form.find('#ba-an').val(),
       bank_code: $form.find('#ba-rn').val(),
    };

    balanced.bankAccount.create(bankAccountData, baCallbackHandler);

  })
})
