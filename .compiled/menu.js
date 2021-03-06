// Generated by LiveScript 1.5.0
(function(){
  var react, filter, whitebox, ref$, cut, money, newAccount, calcWallet, naming, seed, refreshWallet, getContainer, state;
  react = require('react');
  filter = require('prelude-ls').filter;
  whitebox = require('whitebox');
  ref$ = require('./tools.ls'), cut = ref$.cut, money = ref$.money;
  newAccount = require('./new-account.ls');
  calcWallet = require('./calc-wallet.ls');
  naming = require('./naming.ls');
  seed = require('./seed.ls');
  refreshWallet = require('./refresh-wallet.ls');
  getContainer = whitebox.getContainer;
  state = {
    timeout: null
  };
  module.exports = function(arg$){
    var store, current, accounts, refresh, activePage, chooseAccount, manageAccounts, selectPage, pages, createAccount, changeSeed, saveSeed, editSeed, children;
    store = arg$.store;
    if (store == null) {
      return null;
    }
    current = store.current, accounts = store.accounts;
    refresh = function(){
      return refreshWallet(store, function(){});
    };
    activePage = function(page){
      if (current.page === page) {
        return 'active';
      }
    };
    chooseAccount = curry$(function(selected, event){
      return import$(current.account, selected);
    });
    manageAccounts = function(event){
      return current.page = 'accounts';
    };
    selectPage = curry$(function(name, event){
      return current.page = name;
    });
    pages = ['wallets', 'history'];
    createAccount = function(){
      current.account = newAccount(current.seed);
      return calcWallet(store);
    };
    changeSeed = function(event){
      state.timeout = clearTimeout(state.timeout);
      current.seed = event.target.value;
      return state.timeout = setTimeout(createAccount, 2000);
    };
    saveSeed = function(){
      seed.set(current.seed);
      return current.savedSeed = true;
    };
    editSeed = function(){
      return current.savedSeed = false;
    };
    return react.createElement('aside', {
      className: 'menu menu1056479419'
    }, children = [
      react.createElement('div', {
        className: 'box-container'
      }, children = (function(){
        switch (current.savedSeed) {
        case false:
          return react.createElement('div', {
            className: 'box'
          }, children = [
            react.createElement('div', {
              className: 'title'
            }, ' Secret Text'), react.createElement('textarea', {
              onChange: changeSeed,
              value: current.seed + "",
              placeholder: "Secret words"
            }), react.createElement('div', {}, children = react.createElement('button', {
              onClick: saveSeed
            }, ' Save'))
          ]);
        case true:
          return react.createElement('div', {
            className: 'box'
          }, children = react.createElement('div', {}, children = react.createElement('button', {
            onClick: editSeed
          }, ' Edit seed')));
        }
      }())), naming({
        store: store
      }), react.createElement('div', {
        className: 'box-container'
      }, children = store.current.refreshing === false
        ? react.createElement('div', {
          className: 'box'
        }, children = [
          react.createElement('div', {
            className: 'title'
          }, ' Balance'), react.createElement('div', {
            className: 'balance'
          }, ' $ ' + money(current.balanceUsd)), react.createElement('button', {}, children = react.createElement('i', {
            onClick: refresh,
            className: 'zmdi zmdi-reload'
          }))
        ])
        : react.createElement('div', {
          className: 'box'
        }, children = [
          react.createElement('div', {
            className: 'title'
          }, ' Loading...'), react.createElement('div', {
            className: 'balance'
          }, ' $ ' + money(current.balanceUsd))
        ]))
    ]);
  };
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
  function curry$(f, bound){
    var context,
    _curry = function(args) {
      return f.length > 1 ? function(){
        var params = args ? args.concat() : [];
        context = bound ? context || this : this;
        return params.push.apply(params, arguments) <
            f.length && arguments.length ?
          _curry.call(context, params) : f.apply(context, params);
      } : f;
    };
    return _curry();
  }
}).call(this);
