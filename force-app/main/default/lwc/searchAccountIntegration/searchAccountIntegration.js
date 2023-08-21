import { LightningElement,track } from 'lwc';
import getAccountRecords from '@salesforce/apex/Integration_Sherbaz.makeCallout';

export default class SearchAccountIntegration extends LightningElement {

    // 1) To call the connectedCallback for getting and setting data from Apex
connectedCallback(){
this.init();  
}

// 3) Use to store Accounts got from Init method 
@track accountRecords = [];
@track searchTerm = '';

handleSearch(event) {
    this.searchTerm = event.target.value;
  }

get filteredAccountRecord() {
    if (this.searchTerm === '') {
      return this.accountRecords;
    }
    return this.accountRecords.filter(accountRecords => accountRecords.Name.toLowerCase().startsWith(this.searchTerm.toLowerCase()));
  }

// 2) To call in connectedCallback for getting and setting data from Apex 
init(){

console.log('(Init) Start');
getAccountRecords({}).then(success=>{
    this.accountRecords = success;
    console.log('(Init) Account Records '+ JSON.stringify(this.accountRecords));
    this.accountRecords.forEach((account)=> console.log(`Account Name ${account.Name}`));
    ////////////////////////////////////////////////      
    // Sorting the object and storing it into sObjects
    // this.sObjects = success.sort((a, b) => a.label.localeCompare(b.label));

    /* for(let object of this.sObjects){
    console.log(object.label);
    }
    */
    //this.sObjects.forEach((object)=> console.log(object.label));


    //this.totalRecords = success.length; // update total records count                 
    

    //console.log('(Init) sObjects count > '+ this.sObjects.length);
    //console.log('(Init) Apex sObjects list = ', this.sObjects);
    //console.log('(Init) sObjects '+ JSON.stringify(this.sObjects))

    }).catch(error=>{
    console.log("(Init) Error = "+JSON.stringify(error));
    })
    
}

// fruits = [{name:'apple', price:123}, {name:'orange', price:666}];

//   get filteredFruits() {
//     if (this.searchTerm === '') {
//       return this.fruits;
//     }
//     return this.fruits.filter(fruit => fruit.name.toLowerCase().includes(this.searchTerm.toLowerCase()));
//   }

//   handleSearch(event) {
//     this.searchTerm = event.target.value;
//   }
}