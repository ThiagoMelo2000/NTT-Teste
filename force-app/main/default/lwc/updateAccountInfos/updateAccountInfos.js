import { LightningElement, api, wire, track } from 'lwc';
import getAccount from '@salesforce/apex/UpdateAccountInfosController.getAccount';
import updateAccount from '@salesforce/apex/UpdateAccountInfosController.updateAccount';
import verifyInfos from '@salesforce/apex/UpdateAccountInfosController.verifyInfos';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

export default class UpdateAccountInfos extends LightningElement {
    @api recordId;
    @track accountName;
    @track accountNumber;
    @track accountType;
    @track accountId;
    @track disableSave = false;
    wiredAccountResult;

    get typeOptions() {
        return [
            { label: 'CPF', value: 'CPF' },
            { label: 'CNPJ', value: 'CNPJ' },
        ];
    }

    handleTypeChange(event) {
        this.accountType = event.detail.value;
        this.handleInfos(this.accountType, this.accountNumber);
    }

    handleNameChange(event) {
        if(event.detail.value == null){
            this.disableSave = true;
        } else{
            this.handleInfos(this.accountType, this.accountNumber);
            this.accountName = event.detail.value;
        }
    }

    handleNumberChange(event) {
        this.accountNumber = event.detail.value;
        this.handleInfos(this.accountType, event.detail.value);
    }

    async handleInfos(type, accountNumber){
        await verifyInfos({
            type: type,
            accountNumber: accountNumber
        })
        .then(result => {
            this.disableSave = !result
        })
    }

    handleClick() {
        updateAccount({
            name: this.accountName,
            type: this.accountType,
            accountNumber: this.accountNumber,
            accountId: this.accountId
        })
        .then(() => {
            return refreshApex(this.wiredAccountResult);
        })
        .then(() => {
            const fields = {
                Id: this.accountId,
                Name: this.accountName,
                AccountNumber: this.accountNumber,
                Type: this.accountType
            };

            return updateRecord({ fields });
        })
        .catch(error => {
            console.error('Error to update account: ', JSON.stringify(error));
        });
    }

    @wire(getAccount, { accountId: '$recordId' })
    wiredAccountData(result) {
        this.wiredAccountResult = result;
        if (result.data) {
            this.accountId = result.data.Id;
            this.accountName = result.data.Name;
            this.accountNumber = result.data.AccountNumber;
            this.accountType = result.data.Type;
            if(result.AccountNumber == null || result.Name == null){
                this.disableSave = true;
            }
        } else if (result.error) {
            console.error('Error to get account infos: ', JSON.stringify(result.error));
        }
    }
}