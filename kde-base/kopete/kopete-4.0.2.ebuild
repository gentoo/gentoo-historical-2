# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kopete/kopete-4.0.2.ebuild,v 1.2 2008/03/11 00:10:58 philantrop Exp $

EAPI="1"

KMNAME=kdenetwork
inherit kde4-meta

DESCRIPTION="KDE multi-protocol IM client"
KEYWORDS="~amd64 ~x86"
IUSE="+addbookmarks +alias +autoreplace +contactnotes debug gadu groupwise
+highlight +history htmlhandbook +jabber latex +msn +nowlistening +oscar
+privacy qq sms +statistics testbed +texteffect +translator +urlpicpreview
+webpresence winpopup yahoo"
# IUSE="irc jingle meanwhile messenger telepathy"

# plugins: addbookmarks, alias, autoreplace, contactnotes, highlight, history,
# 		latext, nowlistening, privacy, (sqlite?) statistics, texteffect, translator,
#		urlpicpreview, (&& xml2 xslt) webpresence

# protocols: (ssl?) gadu, (qca2?) groupwise, irc (disabled), (&& qca2 idn) jabber,
#		jingle (disabled), meanwhile (not ported), messenger (not ready), msn, oscar,
# 		qq, sms, (decibel?) telepathy (not ready), testbed, winpopup, yahoo

#		irc and jingle are disabled in the package (4.0.2)
#		meanwhile hasn't been ported to KDE4 yet (4.0.2)
#		messenger is the new msn support protocol (it's not ready yet; 4.0.1)
#		telepathy isn't ready yet (4.0.1)

# Tests are KDE-ish.
RESTRICT="test"

RDEPEND="
	dev-libs/libpcre
	kde-base/qimageblitz
	x11-libs/libXScrnSaver
	gadu? ( dev-libs/openssl )
	groupwise? ( app-crypt/qca:2 )
	jabber? ( net-dns/libidn app-crypt/qca:2 )
	statistics? ( dev-db/sqlite:3 )
	webpresence? ( dev-libs/libxml2 dev-libs/libxslt )"
# 	telepathy? ( net-libs/decibel )

DEPEND="${RDEPEND}
	x11-proto/scrnsaverproto"

src_compile() {
	# Xmms isn't in portage, thus forcefully disabled.
	# telepathy and messenger aren't ready yet.
	mycmakeargs="${mycmakeargs}
		-DWITH_Xmms=OFF
		-DWITH_telepathy=OFF
		-DWITH_messenger=OFF
		$(cmake-utils_use_with addbookmarks)
		$(cmake-utils_use_with alias)
		$(cmake-utils_use_with autoreplace)
		$(cmake-utils_use_with contactnotes)
		$(cmake-utils_use_with gadu OPENSSL)
		$(cmake-utils_use_with groupwise)
		$(cmake-utils_use_with groupwise QCA2)
		$(cmake-utils_use_with highlight)
		$(cmake-utils_use_with history)
		$(cmake-utils_use_with jabber IDN)
		$(cmake-utils_use_with jabber QCA2)
		$(cmake-utils_use_with latex)
		$(cmake-utils_use_with msn)
		$(cmake-utils_use_with nowlistening)
		$(cmake-utils_use_with oscar)
		$(cmake-utils_use_with privacy)
		$(cmake-utils_use_with qq)
		$(cmake-utils_use_with sms)
		$(cmake-utils_use_with statistics Sqlite)
		$(cmake-utils_use_with statistics)
		$(cmake-utils_use_with testbed)
		$(cmake-utils_use_with texteffect)
		$(cmake-utils_use_with translator)
		$(cmake-utils_use_with urlpicpreview)
		$(cmake-utils_use_with webpresence LibXml2)
		$(cmake-utils_use_with webpresence LibXslt)
		$(cmake-utils_use_with webpresence)
		$(cmake-utils_use_with winpopup)
		$(cmake-utils_use_with yahoo)"

#		$(cmake-utils_use_with messenger)
#		$(cmake-utils_use_with telepathy)
#		$(cmake-utils_use_with telepathy Decibel)

	kde4-meta_src_compile
}

pkg_postinst() {
#	if use telepathy; then
#		elog "To use kopete telepathy plugins, you need to start gabble first:"
#		elog "GABBLE_PERSIST=1 telepathy-gabble &"
#		elog "export TELEPATHY_DATA_PATH=/usr/share/telepathy/managers/"
#	fi
	if use jabber; then
		echo
		elog "In order to use ssl in jabber, messenger and irc you'll need to have qca-ossl"
		echo
	fi
}
