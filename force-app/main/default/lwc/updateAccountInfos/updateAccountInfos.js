import { LightningElement, api, track } from 'lwc';
import getAccount from '@salesforce/apex/UpdateAccountInfosController.getAccount';
import updateAccount from '@salesforce/apex/UpdateAccountInfosController.updateAccount';

export default class UpdateAccountInfos extends LightningElement {
    @api recordId;
    @track accountName;
    @track accountNumber;
    @track accountType;
    @track accountId;

    get typeOptions() {
        return [
            { label: 'CPF', value: 'CPF' },
            { label: 'CNPJ', value: 'CNPJ' },
        ];
    }

    async connectedCallback() {
        let data = {};
        console.log('ID do Registro Atual: ' + this.recordId);
        this.accountId = this.recordId;
        
        await getAccount({accountId: this.recordId})
        .then(result => {
            console.log('RESULT:: ', JSON.stringify(result));
            data = result;
        })

        this.accountId = data.Id;
        this.accountName = data.Name;
        this.accountNumber = data.AccountNumber;
        this.accountType = data.Type;
    }

    handleTypeChange(event){
        this.accountType = event.detail.value;
        console.log('Tipo de Conta Alterado: ' + this.accountType);
    }

    handleNameChange(event){
        this.accountName = event.detail.value;
        console.log('Nome da Conta Alterado: ' + this.accountName);
    }

    handleNumberChange(event){
        this.accountNumber = event.detail.value;
        console.log('Número da Conta Alterado: ' + this.accountNumber);
    }

    handleClick(){
        console.log('Botão "Salvar" Clicado');

        updateAccount({
            name: this.accountName,
            type: this.accountType,
            accountNumber: this.accountNumber,
            accountId: this.accountId
        })
        .then(result => {
            console.log('Atualização Bem-Sucedida: ', JSON.stringify(result));
        })
        .catch(error => {
            console.error('Erro durante a atualização: ', JSON.stringify(error));
        });

        console.log('Recarregando a Página');
        location.reload();
    }
}