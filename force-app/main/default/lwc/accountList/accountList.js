import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAccountList from '@salesforce/apex/AccountController.getAccountList';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';

export default class AccountList extends NavigationMixin(LightningElement) {

    
  // 3) Use to store Accounts got from Init method 
    @track accounts = [];
    @track stateCodes = [];
  // Use to use Industry picklist values from @wire getPicklistValues  
    @track industryPicklistValue = [];
    @track IndustryError;

  // 6) to store picklist values  
    Ownership = null;
    Industry = null;
    NoOfEmployees = null;
    State = null;
    storeAccountId = null;


   // 9) it uses wire decurator to get Industry picklist values and then store it into @track industryPicklistValue if success else store the error into @track IndustryError
    @wire (getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: INDUSTRY_FIELD })
        industryPicklistValue({data,error}){
          if(data){
          console.log('Industry Picklist values are '+data.values);
          this.industryPicklistValue = data.values;
          this.IndustryError = undefined;
          }
          if(error){
            console.log('Errors while fetching Industry Picklist values are '+error);
            this.industryPicklistValue = undefined;
            this.IndustryError = error;
          }
        } 

  // 10 ) Use to return industry picklist and Statecodes options to html Input ComboBox
   get IndustryOptions() {
    return this.industryPicklistValue;
}    

   get StateCodesOptions() {
   return this.stateCodes;
}



  // 7) use to store values into the account picklist fields
     handleChange(event){
      if(event.target.name == 'accOwnership'){
        this.Ownership = event.target.value;
      }
      else if(event.target.name == 'accIndustry'){
        this.Industry = event.target.value;
      }
      else if(event.target.name == 'accNoOfEmployees'){
        this.NoOfEmployees = event.target.value;
      }
      else if(event.target.name == 'accState'){
        this.State = event.target.value;
      }
  }
    
    
    // 4) Use to return no. of accounts as a Account count in HTML
    get accountCount(){
      return "Accounts ("+this.accounts.length+")";
       
      }

    
   // 1) To call the connectedCallback for getting and setting data from Apex
   connectedCallback(){
      this.init();  
   }


   // 13) To call/select the contact child of the first Account when render
   selectFirstAccount(){ 
    let selectedAccount = null;
    console.log('(selectFirstAccount)  Started');
    if (this.accounts.length>0) {
    selectedAccount = this.accounts[0].Id;
    //this.template.radio[0].checked;
    //this.template.form.group1[0].checked
    console.log('(selectFirstAccount)  Account id = '+this.accounts[0].Id);
    this.template.querySelector('c-contact-list').filter(selectedAccount);
    }
    else{
      this.template.querySelector('c-contact-list').filter(null);
    }
    }

   
   // 2) To call in connectedCallback for getting and setting data from Apex 
   init(){
    
    console.log('(Init) Start');
      getAccountList({ownership : null, industry : null, noOfEmployees : null, stateCode : null}).then(success=>{
        success.accList[0].selected = true; // use to select the first record of the list by making it true
        
        this.accounts=success.accList;
        this.stateCodes=success.stateCodes.map((record)=>({label: record, value: record}));
        //pagination
        this.totalRecords = success.accList.length; // update total records count                 
        // this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
        this.pageSize = 10;
        this.paginationHelper(); // call helper menthod to update pagination logic 
        this.selectFirstAccount();
        //pagination

        console.log('(Init) Account count > '+ success.accList.length);
        console.log('(Init) Apex Account list = ', success.accList);
        console.log('(Init) StateCode '+ JSON.stringify(this.stateCodes))

      }).catch(error=>{
        console.log("(Init) Error = "+JSON.stringify(error));
      })
      
      // just to clear the place holder values into picklists
      this.Ownership = null;
      this.Industry = null;
      this.NoOfEmployees = null;
      this.State = null;
   }



   // 8) use to filter the query via Apex regarding the used picklist fields
   filter(){

    console.log('(filter) Start');
      getAccountList({ownership : this.Ownership, industry : this.Industry, noOfEmployees : this.NoOfEmployees, stateCode : this.State}).then(success=>{
        success.accList[0].selected = true;// use to select the first record of the list by making it true

        this.accounts=success.accList;
        this.stateCodes=success.stateCodes.map((record)=>({label: record, value: record}));
         
        //pagination
        this.totalRecords = success.accList.length; // update total records count                 
        // this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
        this.pageSize = 10;
        this.paginationHelper(); // call helper menthod to update pagination logic 
        this.selectFirstAccount();
        //pagination
        
        console.log('(filter) Account count > '+ success.accList.length);
        console.log('(filter) Apex Account list = ', success.accList);
        console.log('(filter) StateCode '+ JSON.stringify(this.stateCodes))

      }).catch(error=>{
        console.log("(filter) Error = "+JSON.stringify(error));
      })
   }


   // 5) Use to Store Ownership and NoOfEmployees Picklist options and return to html Input ComboBox
   get OwnershipOptions() {
    return [
        { label: 'Public', value: 'Public' },
        { label: 'Private', value: 'Private' },
        { label: 'Public/Private', value: 'Public/Private' },
        { label: 'Subsidiary', value: 'Subsidiary' },
        { label: 'Other', value: 'Other' }
    ];
}

  get NoOfEmployeesOptions() {
  return [
      { label: '<50', value: '<50' },
      { label: '>50 and <150', value: '>50 and <150' },
      { label: '>500 and <1500', value: '>500 and <1500' },
      { label: '>1500', value: '>1500' }
  ];
}


   
  // 4) Use for navigation on a Account detail page by getting Account Id from Html 
   handleNavigateToAccount(event) {
    console.log('(handleNavigateToAccount) Start');
    const accountId = event.target.dataset.contid;
    console.log('(handleNavigateToAccount) Account Id'+accountId);
    this[NavigationMixin.Navigate]({
      type: 'standard__recordPage',
      attributes: {
        recordId: accountId,
        objectApiName: 'Account',
        actionName: 'view'
      }
    });
  }

  // 11) Use to store Account Id to get child Contacts  
  storeAccoundIdMethod(event){
    console.log('(storeAccoundIdMethod) Store Account Id From event.target.value = '+event.target.value);
    
    // storing the accoundID from event 
    this.storeAccountId = event.target.value;
    // Getting child component filter method via query selector
    var childFilterMethod = this.template.querySelector('c-contact-list');
    childFilterMethod.filter(this.storeAccountId);

    console.log('(storeAccoundIdMethod) End of this Method By getting this.storeAccountId = '+this.storeAccountId);
   }
 


   // 12)                                   /////////////////  Pagination

    // pageSizeOptions = [5, 10, 25, 50, 75, 100]; //Page size options
    accounts = []; //All records available in the data table
    columns = []; //columns information available in the data table
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    recordsToDisplay = []; //Records to be displayed on the page
    

    get bDisableFirst() {
        return this.pageNumber == 1;
    }

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    /* // For pagination options
    handleRecordsPerPage(event) {
      this.pageSize = event.target.value;
      this.paginationHelper();
  }
   */
  previousPage() {
      this.pageNumber = this.pageNumber - 1;
      this.paginationHelper();
  }

  nextPage() {
      this.pageNumber = this.pageNumber + 1;
      this.paginationHelper();
  }

  firstPage() {
      this.pageNumber = 1;
      this.paginationHelper();
  }

  lastPage() {
      this.pageNumber = this.totalPages;
      this.paginationHelper();
  }


  // JS function to handel pagination logic 
  paginationHelper() {
      this.recordsToDisplay = [];
      // calculate total pages
      this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
      // set page number 
      if (this.pageNumber <= 1) {
          this.pageNumber = 1;
      } else if (this.pageNumber >= this.totalPages) {
          this.pageNumber = this.totalPages;
      }

      // set records to display on current page 
      for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
          if (i === this.totalRecords) {
              break;
          }
          this.recordsToDisplay.push(this.accounts[i]);
      }
  }


}