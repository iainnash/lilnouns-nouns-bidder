"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GET_TOKEN_VALUES_QUERY = void 0;
const graphql_request_1 = require("graphql-request");
exports.GET_TOKEN_VALUES_QUERY = (0, graphql_request_1.gql) `
  fragment TokenShort on Token {
    id
    symbol
    name
    decimals
    derivedETH
  }
  query getTokenPrices($currencyContracts: [ID!]) {
    bundle(id: "1") {
      ethPrice
    }
    tokens(where: { id_in: $currencyContracts }) {
      ...TokenShort
    }
  }
`;
