import { api, LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getContactList from '@salesforce/apex/ContactController.getContactList';

export default class ContactList extends NavigationMixin(LightningElement) {
    
    // All variables, array, objects
    @api accountid = null;
    @track contacts = [];
    contactCount;
    
    // 1) Use to call init method to  get all contact to display
    connectedCallback(){
        this.init();
    }
   
    // 4) use to return Contact Size
    get contactCountGetter(){
      return 'Contacts ('+this.contactCount+')';
    }
    
    // 2) Use to call the apex method to get all contacts
    init(){ // firstly this.accountid is null to get contacts based on null accountid 
        getContactList({accountId : this.accountid}).
        then(result => {
            this.contacts = result.conList;
            this.contactCount = result.count;
            
            console.log('(init Contact) count> '+ result.count);
            console.log('(init Contact) Apex Contact list = ', result);
        }).
        catch(error => {
            console.log('(init Contact) error .. !', error);
        });
    }
   
  // 3) use to filter the contact regarding AccoundId got from Parent component
   @api filter(parentAccountId){
    this.accountid = parentAccountId;
     console.log('(filter Contact) Account Id = '+parentAccountId);
      getContactList({accountId : parentAccountId}).
      then(result => {
          this.contacts = result.conList;
          this.contactCount = result.count;

          console.log('(filter Contact) count> '+ result.count);
          console.log('(filter Contact) Apex Contact list = ', result);
      }).
      catch(error => {
          console.log('(filter Contact) error .. !', error);
      });
  }
    
    // 5) use to navigate contacts
    handleNavigateToContact(event) {
        console.log('(handleNavigateToContact) Start');
        const contactId = event.target.dataset.contid;
        console.log('(handleNavigateToContact) Contact Id'+contactId);
        this[NavigationMixin.Navigate]({
          type: 'standard__recordPage',
          attributes: {
            recordId: contactId,
            objectApiName: 'Contact',
            actionName: 'view'
          }
        });
      }


    // 6) Refresh Method to get the records again based on the Account Id
    refreshMethod(){
      console.log('(refreshMethod) Start');
      // now init has accountId through @API to pass into getContactList Method 
      this.init();
      console.log('(refreshMethod) End');
    }
}