require! {
    \react
    \whitebox
    \./transactions.ls : { transactions }
    \prelude-ls : { sort-by, reverse, filter }
    \moment
    \./networks.ls
}
.history
    width: 100%
    color: black
    position: relative
    padding-bottom: 20px
    .header
        height: 50px
        box-sizing: border-box
        text-align: left
        padding: 10px
        position: fixed
        background: rgba(white, 0.95)
        left: 0
        top: 0
        width: 100%
        max-width: 400px
        .separator
            min-width: 14px
            display: inline-block
        button 
            outline: none
            cursor: pointer
            border: 0
            background: transparent
            display: inline-block
            vertical-align: top
            margin: 3px
            padding: 0
            border: 1px solid #eae9e9
            border-radius: 3px
            &.active
                border-color: #75cee1
                background: rgba(#75cee1, 0.3)
                background: white
            line-height: 12px
            height: 25px
            width: 33px
            text-align: center
            >*
                vertical-align: middle
                display: inline-block
    .fee
        display: inline-block
        margin-right: 5px
    .balance
        display: inline-block
        >*
            display: inline-block
        .color
            color: black
        .rest
            color: #CCC
    .table
        margin-top: 60px
        width: 100%
        .head, .record
            &.record
                border: 1px solid #CCC
                border-radius: 3px
                margin: 10px
                background: white
                margin-bottom: 1px
            .cell
                padding: 2px 5px
                display: inline-block
                vertical-align: top
                box-sizing: border-box
                text-align: left
                &.network
                    width: 15%
                &.txhash
                    width: 45%
                    a
                        color: black
                &.amount
                    width: 40%
                    text-align: right
            .gray
                color: #CCC
                font-size: 12px
            .type
                text-align: center
            .direction
                font-size: 12px
            &.OUT
                .direction
                    color: red
                .txhash a
                    color: #c79b9b
            &.IN
                .direction
                    color: green
                .txhash a
                    color: #80ad80
    .panel-footer
        padding: 10px
    img
        height: 15px
module.exports = ({ store })->
    cut-tx = (tx)->
        return \none if not tx?
        r = tx.substr(0, 4) + \.. + tx.substr(tx.length - 25, 10) + \.. + tx.substr(tx.length - 4, 4)
        r.to-upper-case!
    ago = (time)->
        moment(time * 1000).from-now!
    date = (time)->
        moment(time * 1000).format!
    filt = store.current.filter
    filter-txs = ({ type, network })->
        type in filt and network in filt
    applied-transactions =
        transactions 
            |> filter filter-txs 
            |> sort-by (.time) 
            |> reverse
    arrow = (type)->
        | type is \IN => "⇨  INC"
        | _ => "⇦ OUT"
    go-back = ->
        store.current.page = \wallets
    extended = (str)->
        | str.index-of('.') > -1 => "#{str}0"
        | _ => "#{str}.0"
    cut-amount = (amount, max)->
        str = amount.to-string!
        res =
            | str.length is max => str
            | str.length >= max => str.substr(0, max - 1) + ".."
            | _ => cut-amount extended(str), max
        res
    amount-beautify = (amount, max)->
        str = cut-amount amount, max
        data = str.match(/(.+[^0])(0+)$/)
        if not data?
            return
                .pug.balance 
                    span.color.pug #{str}
        [_, first, last] = data
        span.pug.balance
            span.color.pug #{first}
            span.rest.pug #{last}
    is-active = (value)->
        if value in filt then \active else ''
    switch-filter  = (value, event)-->
        if value not in filt
            filt.push value
        else 
            filt.splice(filt.index-of(value), 1)
    switch-type-in = switch-filter \IN
    switch-type-out = switch-filter \OUT
    .pug.normalheader.history
        .header.pug
            button.pug(on-click=go-back) < 
            span.pug.separator
            button.pug(class="#{is-active('IN')}" on-click=switch-type-in) IN
            button.pug(class="#{is-active('OUT')}" on-click=switch-type-out) OUT
            span.pug.separator
            for network in Object.keys networks
                button.pug(key="#{network}" class="#{is-active(network)}" on-click=switch-filter(network))
                    img.pug(src="#{networks[network].image}")
        .pug
            .pug.table
                for {network, tx, amount, fee, time, url, type} in applied-transactions
                    .record.pug(class="#{type}" key="#{tx}")
                        .cell.pug.text-center.network
                            .pug
                                img.pug(src="#{networks[network].image}")
                            .pug.direction #{arrow(type)}
                        .cell.pug.txhash
                            a.pug(href="#{url}" target="_blank") #{cut-tx tx}
                            .pug.gray #{ago time}
                        .cell.pug.amount
                            .pug(title="#{amount}") 
                                amount-beautify amount, 8
                            .pug.gray
                                span.pug.fee Fee 
                                amount-beautify fee, 10