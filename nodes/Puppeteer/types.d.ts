declare module '@fye/netsuite-rest-api';

/**
 * Type declaration for puppeteer-extra-plugin-human-typing
 * This plugin provides human-like typing simulation for Puppeteer
 */
declare module 'puppeteer-extra-plugin-human-typing' {
	import type { PuppeteerExtraPlugin } from 'puppeteer-extra-plugin';
	
	interface HumanTypingPlugin extends PuppeteerExtraPlugin {
		(opts?: any): PuppeteerExtraPlugin;
	}
	
	const plugin: HumanTypingPlugin;
	export default plugin;
}