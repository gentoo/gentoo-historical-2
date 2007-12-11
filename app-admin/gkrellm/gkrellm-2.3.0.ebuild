# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gkrellm/gkrellm-2.3.0.ebuild,v 1.8 2007/12/11 08:56:16 vapier Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="Single process stack of various system monitors"
HOMEPAGE="http://www.gkrellm.net/"
SRC_URI="http://members.dslextreme.com/users/billw/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="hddtemp gnutls lm_sensors nls ssl X kernel_FreeBSD"

RDEPEND=">=dev-libs/glib-2
	hddtemp? ( app-admin/hddtemp )
	gnutls? ( net-libs/gnutls )
	lm_sensors? ( sys-apps/lm_sensors )
	nls? ( virtual/libintl )
	ssl? ( dev-libs/openssl )
	X? ( >=x11-libs/gtk+-2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	enewgroup gkrellmd
	enewuser gkrellmd -1 -1 -1 gkrellmd
	TARGET=
	use kernel_FreeBSD && TARGET="freebsd"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-Makefile.patch
	use gnutls && epatch "${FILESDIR}"/${P}-gnutls.patch

	sed -e 's:#user\tnobody:user\tgkrellmd:' \
		-e 's:#group\tproc:group\tgkrellmd:' \
		-i server/gkrellmd.conf || die "sed gkrellmd.conf failed"

	sed -e "s:/usr/lib:/usr/$(get_libdir):" \
		-e "s:/usr/local/lib:/usr/local/$(get_libdir):" \
		-i src/${PN}.h || die "sed ${PN}.h failed"
}

src_compile() {
	if use X ; then
		emake ${TARGET} \
			CC="$(tc-getCC)" \
			INSTALLROOT=/usr \
			INCLUDEDIR=/usr/include/gkrellm2 \
			LOCALEDIR=/usr/share/locale \
			$(use nls || echo enable_nls=0) \
			$(use gnutls || echo without-gnutls=yes) \
			$(use lm_sensors || echo without-libsensors=yes) \
			$(use ssl || echo without-ssl=yes) \
			|| die "emake failed"
	else
		cd server
		emake ${TARGET} \
			CC="$(tc-getCC)" \
			$(use lm_sensors || echo without-libsensors=yes) \
			|| die "emake failed"
	fi
}

src_install() {
	if use X ; then
		emake install${TARGET:+_}${TARGET} \
			$(use nls || echo enable_nls=0) \
			INSTALLDIR="${D}"/usr/bin \
			INCLUDEDIR="${D}"/usr/include \
			LOCALEDIR="${D}"/usr/share/locale \
			PKGCONFIGDIR="${D}"/usr/$(get_libdir)/pkgconfig \
			MANDIR="${D}"/usr/share/man/man1 \
			|| die "emake install failed"
		dosym gkrellm /usr/bin/gkrellm2

		dohtml *.html

		newicon src/icon.xpm ${PN}.xpm
		make_desktop_entry ${PN} GKrellM ${PN}.xpm
	else
		dobin server/gkrellmd || die "dobin failed"

		insinto /usr/include/gkrellm2
		doins server/gkrellmd.h || die "doins failed"
	fi

	doinitd "${FILESDIR}"/gkrellmd || die "doinitd failed"

	insinto /etc
	doins server/gkrellmd.conf || die "doins failed"

	dodoc Changelog CREDITS README
}

pkg_postinst() {
	ewarn "The old executable name 'gkrellm2' is deprecated."
	ewarn "We have provided a compatible symlink for your convenience,"
	ewarn "but this is only temporary.  You should run this as just 'gkrellm'"
	ewarn "instead."
}
