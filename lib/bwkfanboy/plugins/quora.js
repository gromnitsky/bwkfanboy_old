#!/usr/bin/env node

/*
  A companion to 'quora.rb' plugin.
*/

var u = require('util')

function get_timestamps(data) {
	var e = {}
	var link = null
	for (i in data) {
		var f = data[i][0]
	
		if (f == 'FeedStoryItem') {
			link = data[i][3]['q_path']
//			u.puts(link)
		}

		if (f == 'DateTimeComponent') {
			e[link] = data[i][3]['epoch_us']
		}
	}
	return e
}

function collect_stdin(callback) {
	var input = '';
    process.stdin.resume();
	process.stdin.setEncoding('ascii');
    process.stdin.on('data', function (chunk) {
        input += chunk
    });
    process.stdin.on('end', function () {
		callback(input);
    });
};

function prepare4eval(body) {
	var head = "function W2() {}\n" +
"W2.addComponentMetadata = function(foo) {}\n" +
"W2.registerComponents = function(foo) {}\n" +
"W2._ConnectionWarningCls = function(args) {}\n" +
"W2._LoadingCls = function(args) {}\n" +
"W2._InteractionModeCls = function(args) {}\n" +
"\n" +
"document = 'foo'\n" +
"$ = function(foo) { return $ }\n" +
"$.ready = function(foo) {}\n" +
"\n" +
"arr = function(args) {\n" +
"	a = []\n" +
"	a.push(args.callee.name)\n" +
"	for(var i = 0; i < args.length; i++) { a.push(args[i]) }\n" +
"	return a\n" +
"}\n" +
"\n" +
"function LoginButton(args) { return arr(arguments) }\n" +
"function ContextNavigator(args) { return arr(arguments) }\n" +
"function TypeaheadContextText(args) { return arr(arguments) }\n" +
"function TypeaheadResults(args) { return arr(arguments) }\n" +
"function QuestionAddLink(args) { return arr(arguments) }\n" +
"function TitleNotificationsCount(args) { return arr(arguments) }\n" +
"function TextareaAutoSize(args) { return arr(arguments) }\n" +
"function PMsgContainer(args) { return arr(arguments) }\n" +
"function UserAdminMenuLink(args) { return arr(arguments) }\n" +
"function PagedList(args) { return arr(arguments) }\n" +
"function FeedStoryItem(args) { return arr(arguments) }\n" +
"function QuestionLink(args) { return arr(arguments) }\n" +
"function QuestionBestSourceIcon(args) { return arr(arguments) }\n" +
"function AnswerVotingButtons(args) { return arr(arguments) }\n" +
"function TruncatePhraseList(args) { return arr(arguments) }\n" +
"function CommentLink(args) { return arr(arguments) }\n" +
"function DateTimeComponent(args) { return arr(arguments) }\n" +
"function AnswerComments(args) { return arr(arguments) }\n" +
"function Comment(args) { return arr(arguments) }\n" +
"function FeedAnswerItem(args) { return arr(arguments) }\n" +
"function HoverMenu(args) { return arr(arguments) }\n" +
"function ExpandableQText(args) { return arr(arguments) }\n" +
"function TruncatedQText(args) { return arr(arguments) }\n" +
"function UseMobileSite(args) { return arr(arguments) }\n" +
"function LoginSignal(args) { return arr(arguments) }\n" +
"function LiveLogin(args) { return arr(arguments) }\n" +
"function PresencePageMonitor(args) { return arr(arguments) }\n" +
"function UserSig(args) { return arr(arguments) }\n" +
"function HeaderLogo(args) { return arr(arguments) }\n" +
"function NavElement(args) { return arr(arguments) }\n" +
"function UserFollowLink(args) { return arr(arguments) }\n" +
"function FlashClient(args) { return arr(arguments) }\n" +
"function AddQuestionLink(args) { return arr(arguments) }\n" +
"function QTextImageEnlarger(args) { return arr(arguments) }\n" +
"function NavigatorResults(args) { return arr(arguments) }\n" +
"function RateAnswerApproveButton(args) { return arr(arguments) }\n" +
	'';
	var tail = "\n_components;\n";

	return head + body + tail;
}

collect_stdin(function(t) {
//	u.puts(t)

    var script = process.binding('evals').Script
	var code = script.runInThisContext(prepare4eval(t))
// 	u.puts(u.inspect(code, false, null))
 	u.puts(JSON.stringify(get_timestamps(code), null, '  '))
})
