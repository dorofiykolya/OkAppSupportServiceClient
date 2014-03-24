package net
{
	public class ValidateDomain
	{
		public function ValidateDomain()
		{
		}
		public static function validate(str:String):String {
			if (str == null) return '';
			var domain:String = War.DOMAIN;
			var http:String = 'http';
			if (str.length > http.length) {
				if (str.substr(0, http.length) == http) {
					return str;
				}
				if(str.indexOf(domain) == 0){
					return str;
				}
				return domain + str;
			}
			return str;
		}
	}
}