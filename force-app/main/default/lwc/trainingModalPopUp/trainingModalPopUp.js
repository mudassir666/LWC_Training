// import { LightningElement } from 'lwc';

// export default class TrainingModalPopUp extends LightningElement {}

import { LightningElement,api,track } from 'lwc';

import FIRSTNAME from '@salesforce/schema/Contact.FirstName';

import LASTNAME from '@salesforce/schema/Contact.LastName';

import EMAIL from '@salesforce/schema/Contact.Email';

import MOBILE from '@salesforce/schema/Contact.MobilePhone';

import ADDRESS from '@salesforce/schema/Contact.MailingAddress';

import CITY from '@salesforce/schema/Contact.OtherCity';




export default class TrainingModalPopUp extends LightningElement{



   



    firstname = FIRSTNAME;

    lastname = LASTNAME;

    email = EMAIL;

    mobile = MOBILE;

    address = ADDRESS;

    city = CITY;

   

    @api recordId;

    @api objectApiName;








    @track isModalOpen = false;



    openModal()

    {

        this.isModalOpen = true;

    }

    closeModal()

    {

        this.isModalOpen = false;

    }



    submitDetails()

    {

        this.isModalOpen = false;

    }

}