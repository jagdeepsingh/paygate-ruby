window.Paygate = (function() {
  function Paygate() {}

  Paygate.fieldsMap = {
    mid: 'mid',
    locale: 'langcode',
    charset: 'charset',
    title: 'goodname',
    currency: 'goodcurrency',
    amount: 'unitprice',
    payMethod: 'paymethod',
    customerName: 'receipttoname',
    customerEmail: 'receipttoemail',
    cardNumber: 'cardnumber',
    expiryYear: 'cardexpireyear',
    expiryMonth: 'cardexpiremonth',
    cvv: 'cardsecretnumber',
    cardAuthCode: 'cardauthcode',
    responseCode: 'replycode',
    responseMessage: 'replyMsg',
    tid: 'tid',
    profileNo: 'profile_no',
    hashResult: 'hashresult'
  };

  Paygate.openPayApiForm = function() {
    return document.querySelector('form[name=PGIOForm]');
  };

  Paygate.openPayApiScreen = function() {
    return document.querySelector('#PGIOscreen');
  };

  Paygate.openPayApiFields = function() {
    var formChildren = Array.from(this.openPayApiForm().children);
    return formChildren.filter(function(el) {
      return el.tagName === 'INPUT';
    });
  }

  Paygate.findInputByName = function(name) {
    var mappedName = this.fieldsMap[name];
    return this.openPayApiFields().filter(function(el) {
      return el.name === mappedName;
    })[0];
  };

  Paygate.cardAuthCode = function() {
    return this.findInputByName('cardAuthCode').value;
  };

  Paygate.responseCode = function() {
    return this.findInputByName('responseCode').value;
  };

  Paygate.responseMessage = function() {
    return this.findInputByName('responseMessage').value;
  };

  Paygate.tid = function() {
    return this.findInputByName('tid').value;
  };

  Paygate.profileNo = function() {
    return this.findInputByName('profileNo').value;
  };

  Paygate.hashResult = function() {
    return this.findInputByName('hashResult').value;
  };

  Paygate.fillInput = function(field, value) {
    this.findInputByName(field).value = value;
  };

  Paygate.submitForm = function() {
    doTransaction(document.PGIOForm);
  };

  return Paygate;
})();
