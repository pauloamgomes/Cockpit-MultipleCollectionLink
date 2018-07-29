<field-multiplecollectionlink>

    <style>

        .field-multiplecollectionlink:after {
            content: ", ";
        }

        .field-multiplecollectionlink:last-child:after {
            content: "";
        }

        .uk-flex-item-1:hover {
            cursor: move;
        }

        .uk-item-link {
            margin-right: 4px;
        }

        .uk-sortable li {
            line-height: 10px;
            height: auto;
            margin: 0px;
            padding: 6px 4px;
        }

        .uk-sortable li:hover {
            background-color: #f5f5f5;
        }

        .uk-sortable li > div {
            line-height: 10px;
        }

    </style>

    <div class="uk-alert" if="{!opts.links}">
        { App.i18n.get('Reference to collection(s) not defined in the field settings') }
    </div>

    <div class="uk-alert uk-alert-danger" if="{opts.links && error}">
        { App.i18n.get('Failed loading collections') } {opts.links}
    </div>

    <div class="uk-alert" if="{opts.links && !collections && !error}">
        <i class="uk-icon-spinner uk-icon-spin"></i> { App.i18n.get('Loading field') }
    </div>

    <div if="{opts.links && collections}">

        <div class="uk-alert" if="{!link || (link && !link.length)}">
            { App.i18n.get('Nothing linked yet') }. { App.i18n.get('Create link to') }: <a class="field-multiplecollectionlink" each="{collection, index in collections}" title="{ App.i18n.get('Add collection') }" data-uk-tooltip="pos:'bottom'" onclick="{ () => showDialog(index) }">{ collection.label || collection.name }</a>
        </div>

        <div class="uk-alert" if="{!link || (link && link.length)}">
            { App.i18n.get('Create link to') }: <a class="field-multiplecollectionlink" each="{collection, index in collections}" title="{ App.i18n.get('Add collection') }" data-uk-tooltip="pos:'bottom'" onclick="{ () => showDialog(index) }">{ collection.label || collection.name }</a>
        </div>

        <div if="{link && link.length}">

            <div class="uk-panel uk-panel-card uk-panel-box">

                <ul class="uk-list uk-list-space uk-sortable" data-uk-sortable>
                    <li each="{l,index in link}" data-idx="{ index }">
                        <div class="uk-grid uk-grid-small uk-text-small">
                            <div>
                                <a class="uk-text-danger uk-item-link" onclick="{ removeListItem }" title="{ App.i18n.get('Remove Collection') }" data-uk-tooltip="pos:'bottom'"><i class="uk-icon-trash-o"></i></a>
                                <a class="uk-item-link" target="_blank" href="{{ $app['base_url'] }}/collections/entry/{ l.link }/{ l._id }" title="{ App.i18n.get('Edit Collection') }" data-uk-tooltip="pos:'bottom'"><i class="uk-icon-edit"></i></a>
                            </div>
                            <div class="uk-flex-item-1">{ l.display } ({ l.link })</div>
                        </div>
                    </li>
                </ul>

                <div class="uk-panel-box-footer uk-text-small uk-padding-bottom-remove">
                    <a class="uk-text-danger" onclick="{ removeItem }" title="{ App.i18n.get('Remove all collections') }" data-uk-tooltip="pos:'bottom'"><i class="uk-icon-trash-o"></i> { App.i18n.get('Reset') }</a>
                </div>
            </div>

        </div>

    </div>

    <div class="uk-modal">

        <div class="uk-modal-dialog uk-modal-dialog-large" if="{collection}">
            <a href="" class="uk-modal-close uk-close"></a>
            <h3>{ collection.label || collection.name }</h3>

            <div class="uk-margin">

                <div class="uk-form-icon uk-form uk-width-1-1 uk-text-muted">

                    <i class="uk-icon-search"></i>
                    <input class="uk-width-1-1 uk-form-large uk-form-blank" type="text" ref="txtfilter" placeholder="{ App.i18n.get('Filter items...') }" onchange="{ updatefilter }">

                </div>

            </div>

            <div class="uk-overflow-container">

                <div class="uk-alert" if="{ !entries.length && filter && !loading }">
                    { App.i18n.get('No entries found') }.
                </div>

                <table class="uk-table uk-table-striped uk-margin-top" if="{ entries.length }">
                    <thead>
                        <tr>
                            <th class="uk-text-small" each="{field,idx in fields[collection.name]}">
                                <a class="uk-link-muted { parent.sort[field.name] ? 'uk-text-primary':'' }" onclick="{ parent.updatesort }" data-sort="{ field.name }">
                                    { field.label || field.name }
                                    <span if="{parent.sort[field.name]}" class="uk-icon-long-arrow-{ parent.sort[field.name] == 1 ? 'up':'down'}"></span>
                                </a>
                            </th>
                            <th width="20"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr each="{entry,idx in entries}">
                            <td class="uk-text-truncate" each="{field,idy in parent.fields[collection.name]}" if="{ field.name != '_modified' }">
                                <raw content="{ App.Utils.renderValue(field.type, parent.entry[field.name]) }"></raw>
                            </td>
                            <td>{ App.Utils.dateformat( new Date( 1000 * entry._modified )) }</td>
                            <td>
                                <a onclick="{ parent.linkItem }"><i class="uk-icon-link"></i></a>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="uk-alert" if="{ loading }">
                    <i class="uk-icon-spinner uk-icon-spin"></i> {App.i18n.get('Loading...')}.
                </div>

                <div class="uk margin" if="{ loadmore && !loading }">
                    <a class="uk-button uk-width-1-1" onclick="{ load }">
                        { App.i18n.get('Load more...') }
                    </a>
                </div>

            </div>
        </div>
    </div>


    <script>

    var $this = this, modal, collection, collections, _init = function(){

        this.error = this.collections ? false:true;

        this.loadmore   = false;
        this.entries    = [];
        this.fieldsidx  = {};
        this.fields     = {};
        this.display    = {};

        opts.links.forEach(function(link) {
            $this.display[link.name] = link.display;
        });

        this.collections.forEach(function(collection) {
            $this.fieldsidx[collection.name] = {};
            let collectionFields = collection.fields.filter(function(field){
                $this.fieldsidx[collection.name][field.name] = field;
                return field.lst;
            });
            collectionFields.push({name:'_modified', 'label':App.i18n.get('Modified')})
            $this.fields[collection.name] = collectionFields;
        });

        this.update();

    }.bind(this);

    this.link = null;
    this.sort = {'_created': -1};

    this.$updateValue = function(value, field) {

        if (!Array.isArray(value)) {
            value = [].concat(value ? [value]:[]);
        }

        if (JSON.stringify(this.reference) !== JSON.stringify(value)) {
            this.link = value;
            this.update();
        }

    }.bind(this);

    this.on('mount', function(){

        if (!opts.links) return;
        let links = [];

        opts.links.forEach(function(link) {
            links.push(link.name);
        });

        modal = UIkit.modal(App.$('.uk-modal', this.root));

        App.request('/collections/_collections').then(function(data) {
            $this.collections = [];
            Object.keys(data).forEach( key => {
                if (links.includes(key)) {
                    $this.collections.push(data[key]);
                }
            });
            _init();
        });

        App.$(this.root).on('keydown', 'input',function(e){

            if (e.keyCode == 13) {
                e.preventDefault();
                e.stopPropagation();

                $this.updatefilter(e);
                $this.update();
            }
        });

        App.$(this.root).on('stop.uk.sortable', function(){
            $this.updateorder();
        });
    });

    showDialog(index){

        if (opts.limit && this.link && this.link.length >= Number(opts.limit)) {
            App.ui.notify('Maximum amount of items reached');
            return;
        }

        this.collection = this.collections[index];

        modal.show();
        this.load();
    }

    linkItem(e) {

        var _entry = e.item.entry;
        var entry = {
            _id: _entry._id,
            link: this.collection.name,
            display: _entry[this.display[this.collection.name]] || _entry[this.collection.fields[0].name] || 'n/a'
        };

        if (!this.link) {
            this.link = [];
        }

        this.link.push(entry);

        setTimeout(function(){
            modal.hide();
        }, 50);

        this.$setValue(this.link);
    }

    removeItem() {
        this.link = [];
        this.$setValue(this.link);
    }

    removeListItem(e) {
        this.link.splice(e.item.index, 1);
        this.$setValue(this.link);
    }

    load() {

        var limit = 50;

        var options = { sort:this.sort };

        if (this.filter) {
            options.filter = this.filter;
        } else {
            if (opts.filter) {
                options.filter = opts.filter;
            }
        }

        if (!this.collection.sortable) {
            options.limit = limit;
        }

        this.loading = true;

        return App.request('/collections/_find', {collection:this.collection.name, options: options}).then(function(data){
            this.entries = data;

            this.ready    = true;
            this.loadmore = data.length && data.length == limit;

            this.loading = false;

            this.update();

        }.bind(this))
    }

    updatefilter(e) {

        var load = this.filter ? true:false;

        this.filter = null;

        if (this.refs.txtfilter.value) {

            var filter       = this.refs.txtfilter.value,
                criterias    = [],
                allowedtypes = ['text','longtext','boolean','select','html','wysiwyg','markdown','code'],
                criteria;

            if (App.Utils.str2json('{'+filter+'}')) {

                filter = App.Utils.str2json('{'+filter+'}');

                var key, field;

                for (key in filter) {

                    field = this.fieldsidx[this.collection.name][key] || {};

                    if (allowedtypes.indexOf(field.type) !== -1) {

                        criteria = {};
                        criteria[key] = field.type == 'boolean' ? filter[key]: {'$regex':filter[key]};
                        criterias.push(criteria);
                    }
                }

                if (criterias.length) {
                    this.filter = {'$and':criterias};
                }

            } else {

                this.collection.fields.forEach(function(field){

                   if (field.type != 'boolean' && allowedtypes.indexOf(field.type) !== -1) {
                       criteria = {};
                       criteria[field.name] = {'$regex':filter};
                       criterias.push(criteria);
                   }

                });

                if (criterias.length) {
                    this.filter = {'$or':criterias};
                }
            }

        }

        if (this.filter || load) {

            if (opts.filter) {

                Object.keys(opts.filter).forEach(function(k) {
                    switch(k) {
                        case '$and':
                        case '$or':
                            if ($this.filter[k]) {
                                this.filter[k] = this.filter[k].concat(opts.filter[k]);
                            } else {
                                $this.filter[k] = opts.filter[k];
                            }
                            break;
                        default:
                            $this.filter[k] = opts.filter[k];
                    }
                });

                this.filter = opts.filter;
            }

            this.entries = [];
            this.loading = true;
            this.load();
        }

        return false;
    }

    updatesort(e, field) {

        field = e.target.getAttribute('data-sort');

        if (!field) {
            return;
        }

        if (!this.sort[field]) {
            this.sort        = {};
            this.sort[field] = 1;
        } else {
            this.sort[field] = this.sort[field] == 1 ? -1:1;
        }

        this.entries = [];

        this.load();
    }

    updateorder() {

        var items = [];

        App.$($this.root).css('height', App.$($this.root).height());

        App.$('.uk-sortable', $this.root).children().each(function(){
            items.push($this.link[Number(this.getAttribute('data-idx'))]);
        });

        $this.link = [];
        $this.update();

        setTimeout(function() {
            $this.link = items;
            $this.$setValue($this.link);
            $this.update();

            setTimeout(function(){
                $this.root.style.height = '';
            }, 30)
        }, 10);
    }


    </script>

</field-multiplecollectionlink>
