import { flush, render } from '@stencil/core/testing';
import { <%= class_name %> } from './<%= file_name %>';

describe('<%= file_name %>', () => {
  it('should build', () => {
    expect(new <%= class_name %>()).toBeTruthy();
  });

  describe('rendering', () => {
    let element;

    beforeEach(async () => {
      element = await render({
        components: [<%= class_name %>],
        html: '<<%= file_name %>></<%= file_name %>>'
      });
    });

    it('greets', () => {
      expect(element.textContent.trim()).toEqual('Hello, World!');
    });
  });
});
