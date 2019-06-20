# Cockpit-MultipleCollectionLink

Extend Cockpit core fields with a Multiple Collection Link Field.

## Installation

1. Download zip and extract to 'your-cockpit-docroot/addons' (e.g. cockpitcms/addons/multiplecollectionlink)
2. When adding a new field to your collection the MultipleCollectionLink shall be present

## Usage

Field definition is similar to the existing CollectionLink, main difference resides on the links attribute, instead of a collection it consists of an array of collection names:

```json
{
  "links": [
    {
      "name": "colection1",
      "display": "fieldname"
    },
    {
      "name": "collection2",
      "display": "fieldname"
    },
    {
      "name": "collection3",
      "display": "fieldname"
    }
  ],
  "limit": false
}
```

In the below example and assuming that you have two collections, named carousel and block, you can create a link to them using:

```json
{
  "links": [
    {
      "name": "carousel",
      "display": "name"
    },
    {
      "name": "block",
      "display": "name"
    }
  ],
  "limit": false
}
```

![Example Usage](https://api.monosnap.com/rpc/file/download?id=HwyRbyxwEBJeuyTyoyAiBuRDCMz7Ex)

The name of the link is the collection name and the display is the field name of the collection to be displayed when listing/viewing collections.

The limit consists of a numeric value that restricts the number of linked collections.

The addon provides also the flexibility to enhance the display of items in the collection list, by default a tooltip is provided with a number of linked items, but it can be replaced with a list of all links (display val

```json
{
  "links": [
    {
      "name": "carousel",
      "display": "name"
    },
    {
      "name": "block",
      "display": "name"
    }
  ],
  "viewMode": "list"
}
```

## Copyright and license

Copyright 2018 pauloamgomes under the MIT license.
