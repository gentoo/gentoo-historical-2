# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-qtimm/scim-qtimm-0.6_pre20040813.ebuild,v 1.2 2004/08/16 14:09:54 usata Exp $

S="${WORKDIR}/${PN}"

DESCRIPTION="Qt immodules input method framework plugin for SCIM"
HOMEPAGE="http://scim.freedesktop.org/"
#SRC_URI="http://freedesktop.org/~cougar/${PN}/${MY_P}.tar.bz2"
SRC_URI="mirror://gentoo/${P/_pre/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls"

RDEPEND=">=app-i18n/scim-0.99.6
	>=x11-libs/qt-3.3.2
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
	sys-devel/autoconf
	sys-devel/automake"

pkg_setup() {
	ewarn
	ewarn "You need to install >=x11-libs/qt-3.3.2 with cjk USE flag enabled."
	ewarn
	if [ ! -e /usr/qt/3/include/qinputcontext.h ] ; then
		die "You need to rebuild >=x11-libs/qt-3.3.2 with cjk USE flag enabled."
	fi
	if [ ! -e /usr/qt/3/plugins/inputmethods/libqimsw-none.so ] ; then
		die "Your Qt was not built against the latest immodule API. Please rebuild >=x11-libs/qt-3.3.2."
	fi
}

src_compile() {
	addpredict /usr/qt/3/etc/settings
	./bootstrap || die "bootstrap failed"

	econf `use_enable nls` || die
	emake -j1 || die "make failed. Please make sure you enabled cjk IUSE flag when you compiled x11-libs/qt."
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc AUTHORS ChangeLog README NEWS TODO
}

pkg_postinst() {
	einfo
	einfo "After you emerged ${PN}, run"
	einfo "	% qtconfig"
	einfo "and select your immodule to enable ${PN}."
	einfo
}
