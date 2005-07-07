# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/unixODBC/unixODBC-2.2.8.ebuild,v 1.21 2005/07/07 04:31:57 caleb Exp $

inherit eutils gnuconfig multilib

DESCRIPTION="ODBC Interface for Linux"
HOMEPAGE="http://www.unixodbc.org/"
SRC_URI="http://www.unixodbc.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc ~sparc mips ~alpha arm hppa ~amd64 s390 ppc64"
IUSE="qt gnome"

DEPEND="virtual/libc
	>=sys-libs/readline-4.1
	>=sys-libs/ncurses-5.2
	!mips? (
		gnome? ( gnome-base/gnome-libs )
		qt? ( =x11-libs/qt-3* )
	)"

# the configure.in patch is required for 'use qt'
src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}

	# braindead check in configure fails - hack approach
	epatch ${FILESDIR}/unixODBC-2.2.6-configure.in.patch

	libtoolize --copy --force || die "libtoolize failed"
	autoconf || die "autoconf failed"
}

src_compile() {
	local myconf

	if use qt && ! use mips
	then
		myconf="--enable-gui=yes --x-libraries=/usr/$(get_libdir) "
	else
		myconf="--enable-gui=no"
	fi

	# Fix multilib-strict BUG #94262
	myconf="${myconf} --libdir=\${exec_prefix}/$(get_libdir)"

	# Detect mips systems properly
	gnuconfig_update

	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --sysconfdir=/etc/unixODBC \
		    ${myconf} || die

	make || die

	if use gnome
	then
		# Symlink for configure
		ln -s ${S}/odbcinst/.libs ./lib
		# Symlink for libtool
		ln -s ${S}/odbcinst/.libs ./lib/.libs
		cd gODBCConfig
		./configure --host=${CHOST} \
				--with-odbc=${S} \
				--prefix=/usr \
				--x-libraries=/usr/$(get_libdir) \
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

	if use gnome
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
