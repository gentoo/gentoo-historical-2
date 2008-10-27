# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/xxv/xxv-1.2.1359.ebuild,v 1.1 2008/10/27 22:08:07 hd_brummy Exp $

inherit eutils versionator

MY_PV=$(get_version_component_range 3)
MY_P="${PN}-${MY_PV}"

DESCRIPTION="WWW Admin for the VDR (Video Disk Recorder)"
HOMEPAGE="http://xxv.berlios.de/content/view/40/1/"
SRC_URI="http://vdr.websitec.de/download/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mplayer themes"

RDEPEND=">=media-video/vdr-1.2.6
	media-video/vdr2jpeg
	media-fonts/ttf-bitstream-vera
	dev-db/mysql
	virtual/perl-CGI
	virtual/perl-Digest-MD5
	virtual/perl-Getopt-Long
	virtual/perl-MIME-Base64
	virtual/perl-Time-HiRes
	dev-perl/Compress-Zlib
	dev-perl/Config-Tiny
	dev-perl/Digest-HMAC
	dev-perl/Encode-Detect
	dev-perl/GD
	dev-perl/DateManip
	dev-perl/DBD-mysql
	dev-perl/DBI
	dev-perl/Event
	dev-perl/IO-Socket-INET6
	dev-perl/JSON
	dev-perl/Linux-Inotify2
	dev-perl/Locale-gettext
	dev-perl/MP3-Info
	dev-perl/Net-Amazon
	dev-perl/Net-Telnet
	dev-perl/Net-XMPP
	dev-perl/Proc-ProcessTable
	dev-perl/TextToHTML
	dev-perl/Template-Toolkit
	dev-perl/SOAP-Lite
	dev-perl/XML-RSS
	themes? ( >=x11-themes/${PN}-skins-1.2.1359 )"

PDEPEND="mplayer? ( media-video/mplayer )"

SHAREDIR="/usr/share/${PN}"
LIBDIR="/usr/lib/${PN}"

DB_VERS="30"

db_update_check() {

	DB_VERS_OLD="`cat /var/db/pkg/net-www/xxv-*/xxv-*.ebuild | grep DB_VERS | head -n 1 | cut -c10-11`"

	if [ "${DB_VERS_OLD}" -lt "${DB_VERS}" ]; then
		echo
		elog "An update of XXV Database is needed !!!"
		echo
		elog "cd ${SHAREDIR}/contrib"
		elog "run ./update-xxv -h for more info"
		echo
	else
		elog "If this is a new install"
		elog "You have to create an empty DB for XXV"
		echo
		elog "do this by:"
		elog "cd ${SHAREDIR}/contrib"
		eerror "read the README"
		elog "edit create-database.sql and run"
		elog "emerge --config ${PN}"
		echo
		elog "Set your own language in"
		elog "${SHAREDIR}/locale"
		echo
		elog "For First Time Login in Browser use:"
		elog "Pass:Login = xxv:xxv"
		echo
		eerror "edit /etc/xxv/xxvd.cfg !"
	fi
}

pkg_setup() {

	if ! built_with_use dev-perl/GD png gif ; then
		echo
		eerror "Please recompile dev-perl/GD with"
		eerror "USE=\"png gif\""
		die "dev-perl/GD need png and gif support"
	fi

	if ! has_version "net-www/${PN}"; then
		echo
		einfo	"Before you install xxv at first time you should read"
		einfo	"http://www.vdr-wiki.de/wiki/index.php/Xxv  German only available"
		echo
	fi

	db_update_check
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i "${S}"/bin/xxvd \
		-e "s:debian:Gentoo:" \
		-e "s:/var/log/xxvd.log:/var/log/xxv/xxvd.log:" \
		-e "s:/var/run/xxvd.pid:/var/run/xxv/xxvd.pid:" \
		-e "s:\$RealBin/../lib:${LIBDIR}:" \
		-e "s:\$RealBin/../locale:${SHAREDIR}/locale:" \
		-e "s:\$RealBin/../lib/XXV/MODULES:${LIBDIR}/XXV/MODULES:" \
		-e "s:\$RealBin/../etc/xxvd.cfg:/etc/xxv/xxvd.cfg:" \
		-e "s:\$RealBin/../doc:/usr/share/doc/${P}:" \
		-e "s:HTMLDIR     => \"\$RealBin/../:HTMLDIR     => \"${SHAREDIR}/skins:" \
		-e "s:\$RealBin/../share/vtx:${SHAREDIR}/vtx:" \
		-e "s:\$RealBin/../lib/XXV/OUTPUT:${LIBDIR}/XXV/OUTPUT:" \
		-e "s:\$RealBin/../share/news:${SHAREDIR}/news:" \
		-e "s:\$RealBin/../contrib:${SHAREDIR}/contrib:" \
		-e "s:\$RealBin/../share/fonts/:/usr/share/fonts/:"

	sed -i "s:\$RealBin/../lib:${LIBDIR}:" ./locale/xgettext.pl
}

src_compile() {
:
}

src_install() {

	newinitd "${FILESDIR}"/xxv.utf8 xxv

	dobin	bin/xxvd

	insinto /etc/"${PN}"
	newins "${FILESDIR}"/xxvd-1.0.cfg xxvd.cfg

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/xxvd-logrotate xxvd

	diropts -m755 -ovdr -gvdr
	keepdir /var/cache/xxv
	keepdir /var/run/xxv
	keepdir /var/log/xxv

	insinto "${LIBDIR}"
	doins -r "${S}"/lib/*

	insinto "${SHAREDIR}"
	doins -r "${S}"/share/news

	insinto "${SHAREDIR}"/locale
	doins -r "${S}"/locale/*
	fperms 0755 "${SHAREDIR}"/locale/xgettext.pl

	insinto "${SHAREDIR}"/contrib
	doins -r "${S}"/contrib/*
	fperms 0755 "${SHAREDIR}"/contrib/update-xxv

	insinto "${SHAREDIR}"/skins
	doins -r "${S}"/{html,wml}
	doins "${S}"/doc/docu.tmpl

	cd "${S}"/doc
	insinto /usr/share/doc/"${P}"
	doins docu.tmpl CHANGELOG LIESMICH NEWS README TUTORIAL.txt.gz
	fowners vdr:vdr /usr/share/doc/"${P}"

	doman xxvd.1
}

pkg_config() {

		cd "${ROOT}"/"${SHAREDIR}"
		cat ./contrib/create-database.sql | mysql -u root -p
}

pkg_postrm() {

	einfo "Cleanup for old "${P}" files"
	rm -r /usr/share/doc/"${P}"
}
