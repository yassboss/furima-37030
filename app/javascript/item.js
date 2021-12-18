function calc (){
  const itemPrice = document.getElementById("item-price");
  itemPrice.addEventListener("keyup", () => {
    const salePrice = itemPrice.value;
    const addTaxPrice = document.getElementById("add-tax-price");
    const profit = document.getElementById("profit");
    addTaxPrice.innerHTML = Math.trunc(salePrice * 0.1);
    profit.innerHTML = salePrice - addTaxPrice.innerHTML;
  });
}

window.addEventListener('load', calc);