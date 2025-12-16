## AzCopy scripts for the daily upload automatization

### 1. What will be needed?
>- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest&pivots=winget)
>- [AzCopy](https://github.com/Azure/azure-storage-azcopy/releases/)

### 2. How to setup the directories?
> Create a directory on C:\ with the name _azcopy_ and put the _azcopy.exe_ inside.
>
> Inside this directory, create an other one with the name _scripts_ and put the scripts into it.
>
> Create a new directory with the name _exports_ and this will be your main directory for the .csv datas you will upload to your Azure Blob Storage.
>
> In the end, it should look like this:

![It should look like this](/images/img1.png)
