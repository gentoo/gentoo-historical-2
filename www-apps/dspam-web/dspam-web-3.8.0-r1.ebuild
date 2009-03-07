# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/dspam-web/dspam-web-3.8.0-r1.ebuild,v 1.2 2009/03/07 20:49:50 betelgeuse Exp $

EAPI="2"

inherit webapp eutils autotools

PATCHES_RELEASE_DATE="20071231"

DESCRIPTION="Web based administration and user controls for dspam"
HOMEPAGE="http://dspam.nuclearelephant.com/"
SRC_URI="http://dspam.nuclearelephant.com/sources/dspam-${PV}.tar.gz
	mirror://gentoo/dspam-${PV}-patches-${PATCHES_RELEASE_DATE}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

DEPEND=""
DEPEND="
	>=mail-filter/dspam-${PV}[-user-homedirs]
	dev-perl/GD[png]
	dev-perl/GD-Graph3d
	dev-perl/GDGraph
	dev-perl/GDTextUtil"

# some FHS-like structure
HOMEDIR="/var/spool/dspam"
CONFDIR="/etc/mail/dspam"

S="${WORKDIR}/dspam-${PV}"

src_prepare() {
	EPATCH_SUFFIX="patch"
	epatch "${WORKDIR}"/patches

	AT_M4DIR="${S}/m4"
	eautoreconf
}

src_configure() {
	econf \
			--with-dspam-home=${HOMEDIR} \
			--sysconfdir=${CONFDIR}  || die "econf failed"
}

src_compile() {
	cd "${S}/webui"
	default
}

src_install() {
	webapp_src_preinst

	cd "${S}/webui"
	insinto "${MY_HTDOCSDIR}"
	insopts -m644
	doins htdocs/*.{css,gif}
	insinto "${MY_CGIBINDIR}/templates"
	doins cgi-bin/templates/*.html
	insinto "${MY_CGIBINDIR}"
	doins cgi-bin/{admins,configure.pl,default.prefs,rgb.txt,*.cgi}

	webapp_configfile "${MY_CGIBINDIR}"/{admins,configure.pl,default.prefs,rgb.txt}

	webapp_hook_script "${FILESDIR}/setperms"
	webapp_postinst_txt en "${FILESDIR}/postinst-en.txt"

	webapp_src_install
}

pkg_postinst() {
	ewarn "If you're using apache dspam-web's config requires the scripts in the cgi-bin"
	ewarn "to be run as dspam:dspam. You will have to put a global SuexecUserGroup"
	ewarn "declaration in the main server config which will force everything in cgi-bin"
	ewarn "to run as dspam:dspam."
	ewarn "You should use a dedicated virtual host for this application or at least"
	ewarn "one that don't have any other cgi scripts."
	echo
	webapp_pkg_postinst
}
