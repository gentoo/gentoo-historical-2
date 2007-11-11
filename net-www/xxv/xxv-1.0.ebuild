# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/xxv/xxv-1.0.ebuild,v 1.1 2007/11/11 13:46:30 hd_brummy Exp $

inherit eutils

DESCRIPTION="WWW Admin for the VDR (Video Disk Recorder)"
HOMEPAGE="http://xxv.berlios.de/content/view/37/1/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="mplayer"

RDEPEND=">=media-video/vdr-1.2.6
	perl-core/Test-Simple
	perl-core/MIME-Base64
	perl-core/Time-HiRes
	dev-perl/DBI
	dev-perl/Event
	dev-perl/URI
	dev-perl/Locale-gettext
	dev-perl/DBD-mysql
	dev-db/mysql
	dev-perl/Locale-gettext
	dev-perl/WWW-Mechanize
	dev-perl/GD
	dev-perl/GDGraph
	dev-perl/GD-Graph3d
	dev-perl/Proc-ProcessTable
	dev-perl/WWW-Mechanize-FormFiller
	dev-perl/XML-RSS
	dev-perl/Net-XMPP
	dev-perl/Term-ReadLine-Perl
	dev-perl/Term-ReadLine-Gnu
	dev-perl/TimeDate
	dev-perl/Template-Toolkit
	dev-perl/Log-Log4perl
	dev-perl/SOAP-Lite
	dev-perl/Net-IP
	dev-perl/Data-Random
	dev-perl/Net-Amazon
	dev-perl/JSON
	dev-perl/Net-Telnet
	dev-perl/Socket6
	dev-perl/IO-Socket-INET6
	media-video/vdr2jpeg
	media-fonts/ttf-bitstream-vera"

PDEPEND="mplayer? ( media-video/mplayer )"

SHAREDIR="/usr/share/${PN}"
LIBDIR="/usr/lib/${PN}"

DB_VERS="25"

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

	epatch "${FILESDIR}"/"${P}"-logerror.patch
}

src_compile() {
:
}

src_install() {

	doinitd "${FILESDIR}"/xxv

	dobin	bin/xxvd

	insinto /etc/"${PN}"
	newins "${FILESDIR}"/xxvd-"${PV}".cfg xxvd.cfg

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/xxvd-logrotate xxvd

	diropts -m755 -ovdr -gvdr
	keepdir /var/cache/xxv
	keepdir /var/run/xxv
	keepdir /var/log/xxv

	insinto "${LIBDIR}"
	doins -r "${S}"/lib/*

	insinto "${SHAREDIR}"
	doins -r "${S}"/share/{news,vtx}

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
	doins docu.tmpl CHANGELOG.txt COPYING.txt LIESMICH.txt NEWS.txt README.txt TODO.txt TUTORIAL.txt.gz
	fowners vdr:vdr /usr/share/doc/"${P}"

	doman xxvd.1
}

pkg_postinst() {

	if has_version "net-www/${PN}"; then
		if has_version "=<net-www/${PN}-0.91_pre1002" ; then
			echo
			einfo "An update of XXV Database is needed"
			echo
			einfo "emerge --config ${PN}"
			echo
			einfo "will update your XXV Database"
		fi
	else
		einfo "You have to create a empty DB for XXV"
		einfo "do this by:"
		einfo "cd ${SHAREDIR}/contrib"
		eerror "read the README"
		einfo "edit create-database.sql and run"
		einfo "emerge --config ${PN}"
		echo
		einfo "Set your own language in"
		einfo "${SHAREDIR}/locale"
		echo
		einfo "For First Time Login in Browser use:"
		einfo "Pass:Login = xxv:xxv"
		echo
		eerror "edit /etc/xxv/xxvd.cfg !"
	fi
}

pkg_config() {

	if has_version "=<net-www/${PN}-0.91_pre1002"; then
		cd "${ROOT}"/"${SHAREDIR}"/contrib
		./update-xxv
	else
		cd "${ROOT}"/"${SHAREDIR}"
		cat ./contrib/create-database.sql | mysql -u root -p
	fi
}

pkg_postrm() {

	einfo "Cleanup for old "${P}" files"
	rm -r /usr/share/doc/"${P}"
}
