# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/unixODBC/unixODBC-2.2.11-r1.ebuild,v 1.14 2006/10/09 18:33:11 malc Exp $

inherit eutils

DESCRIPTION="ODBC Interface for Linux"
HOMEPAGE="http://www.unixodbc.org/"
SRC_URI="http://www.unixodbc.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="qt3 gnome"

DEPEND="virtual/libc
	>=sys-libs/readline-4.1
	>=sys-libs/ncurses-5.2
	gnome? ( gnome-base/gnome-libs )
	qt3? ( =x11-libs/qt-3* )"

# the configure.in patch is required for 'use qt3'
src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"

	epatch "${FILESDIR}"/${P}-flex.patch #110167
	# braindead check in configure fails - hack approach
	epatch "${FILESDIR}"/${P}-configure.in.patch
	epatch "${FILESDIR}"/${P}-Makefile.am.patch
	aclocal && \
	libtoolize -c -f && \
	automake && \
	autoconf || die "autotools failed"
}

src_compile() {
	local myconf

	if use qt3 && ! use mips;
	then
		myconf="--enable-gui=yes --x-libraries=/usr/lib "
	else
		myconf="--enable-gui=no"
	fi

	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --sysconfdir=/etc/unixODBC \
			--libdir=/usr/$(get_libdir) \
		    ${myconf} || die

	make || die

	if use gnome;
	then
		# Symlink for configure
		ln -s ${S}/odbcinst/.libs ./lib
		# Symlink for libtool
		ln -s ${S}/odbcinst/.libs ./lib/.libs
		cd gODBCConfig
		./configure --host=${CHOST} \
				--with-odbc=${S} \
				--prefix=/usr \
				--x-libraries=/usr/lib \
				--libdir=/usr/$(get_libdir) \
				--sysconfdir=/etc/unixODBC \
				${myconf} || die

		# not sure why these symlinks are needed. busted configure, i guess...
		ln -s ../depcomp .
		ln -s ../libtool .
		make || die
		cd ..
	fi
}

src_install() {
	make DESTDIR=${D} install || die

	if use gnome;
	then
		cd gODBCConfig
		make DESTDIR=${D} install || die
		cd ..
	fi

	dodoc AUTHORS ChangeLog NEWS README*
	find doc/ -name "Makefile*" -exec rm '{}' \;
	dohtml doc/*
	prepalldocs
}
