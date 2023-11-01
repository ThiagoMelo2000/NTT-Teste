import { LightningElement, api, wire } from 'lwc';
import getAccount from '@salesforce/apex/UpdateAccountInfosController.getAccount';
import updateAccount from '@salesforce/apex/UpdateAccountInfosController.updateAccount';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

export default class UpdateAccountInfos extends LightningElement {
    @api recordId;
    @api accountName;
    @api accountNumber;
    @api accountType;
    @api accountId;
    wiredAccountResult;

    get typeOptions() {
        return [
            { label: 'CPF', value: 'CPF' },
            { label: 'CNPJ', value: 'CNPJ' },
        ];
    }

    handleTypeChange(event) {
        this.accountType = event.detail.value;
    }

    handleNameChange(event) {
        this.accountName = event.detail.value;
    }

    handleNumberChange(event) {
        this.accountNumber = event.detail.value;
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
            console.error('Erro durante a atualização: ', JSON.stringify(error));
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
        } else if (result.error) {
            console.error('Erro ao buscar os dados da conta: ', JSON.stringify(result.error));
        }
    }
}