import { LightningElement } from 'lwc';

export default class HppUtility extends LightningElement {

    
}

export function  fetchQueryParameters() {
    var params = {};

    var searchParams = [];

    let search = location.search;
    search = search.startsWith("?") ? search.substring(1) : search;

    search.split("&").forEach(element => {
        if (element.startsWith("?q=") || element.startsWith("q=")) {
            let decompressedValue = decompressQueryParams(element.split("=")[1]);
            searchParams.push("q=" + decompressedValue);
        } else {
            searchParams.push(element);
        }
    });

    if (searchParams.length > 0) {
        search = searchParams.join("&");
    }
    if (search) {
        try {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value);
            });
        } catch (error) {
            return params;
        }
    }

    return params;
}

export function filterArrayList ( inputArrayList, removestring ) {
      const filterlist = inputArrayList.filter(item => item != removestring);  
      console.log (' filtered list ', JSON.stringify (filterlist));
      return filterlist;
}