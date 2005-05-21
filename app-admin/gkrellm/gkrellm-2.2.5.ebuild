# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gkrellm/gkrellm-2.2.5.ebuild,v 1.7 2005/05/21 08:15:50 corsair Exp $

inherit eutils

DESCRIPTION="Single process stack of various system monitors"
HOMEPAGE="http://www.gkrellm.net/"
SRC_URI="http://members.dslextreme.com/users/billw/gkrellm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ppc64 sparc x86"
IUSE="X nls ssl"

DEPEND="=dev-libs/glib-1*
	ssl? ( dev-libs/openssl )
	X? ( >=x11-libs/gtk+-2.0.5
		>=x11-libs/pango-1.4.0 )"
RDEPEND="${DEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${P/a/}

src_compile() {
	local myconf
	if ! use nls; then
		sed -i "s:enable_nls=1:enable_nls=0:" Makefile || die
	fi

	sed -i -e 's:INSTALLROOT ?= /usr/local:INSTALLROOT ?= ${D}/usr:' \
		-e "s:\(PKGCONFIGDIR ?= \$(INSTALLROOT)/\)lib:\1$(get_libdir):" \
		Makefile || die

	sed -i -e "s:/usr/lib:/usr/$(get_libdir):" \
		-e "s:/usr/local/lib:/usr/local/$(get_libdir):" \
		src/gkrellm.h || die

	if use X
	then
	use ssl || myconf="without-ssl=yes"
		PREFIX=/usr emake ${myconf} || die
	else
		cd ${S}/server
		emake glib12=1 || die
	fi
}

src_install() {
	dodir /usr/{bin,include,share/man}

	if use X
	then
		keepdir /usr/share/gkrellm2/themes
		keepdir /usr/$(get_libdir)/gkrellm2/plugins

		make DESTDIR=${D} install \
			INSTALLDIR=${D}/usr/bin \
			MANDIR=${D}/usr/share/man/man1 \
			INCLUDEDIR=${D}/usr/include \
			LOCALEDIR=${D}/usr/share/locale \
			PKGCONFIGDIR=${D}/usr/$(get_libdir)/pkgconfig

		cd ${S}
		mv gkrellm.1 gkrellm2.1

		mv src/gkrellm src/gkrellm2
		dobin src/gkrellm2
		rm -f ${D}/usr/bin/gkrellm
	else
		cd ${S}/server
		dobin gkrellmd
		cd ${S}
		rm gkrellm.1
	fi

	rm -f ${D}/usr/share/man/man1/*
	doman *.1

	exeinto /etc/init.d
	doexe ${FILESDIR}/gkrellmd

	insinto /etc
	doins server/gkrellmd.conf

	dodoc CREDITS INSTALL README Changelog
	dohtml *.html
}
