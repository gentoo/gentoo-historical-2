# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/unixODBC/unixODBC-2.2.12.ebuild,v 1.17 2010/06/19 00:34:18 abcd Exp $

PATCH_VERSION="2.2.12-r0"
PATCH_P="${PN}-${PATCH_VERSION}-patches"

inherit eutils multilib autotools gnuconfig libtool

DESCRIPTION="ODBC Interface for Linux."
HOMEPAGE="http://www.unixodbc.org/"
SRC_URI="http://www.unixodbc.org/${P}.tar.gz
		mirror://gentoo/${PATCH_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE="gnome"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

RDEPEND=">=sys-libs/readline-4.1
	>=sys-libs/ncurses-5.2
	gnome? ( gnome-base/libgnomeui )
	sys-devel/libtool"
DEPEND="${RDEPEND}
	gnome? ( dev-vcs/cvs )" # see Bug 173256

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${WORKDIR}"/${PATCH_P}/*
	epatch \
		"${FILESDIR}/350-${P}-gODBCConfig-as-needed.patch" \
		"${FILESDIR}/360-${P}-libltdlfixes.patch"

	# Remove bundled libltdl copy
	rm -rf libltdl

	eautoreconf

	if use gnome ; then
		cd gODBCConfig
		touch ChangeLog
		autopoint -f || die "autopoint -f failed"
		eautoreconf --install
	fi
}

src_compile() {
	local myconf="--enable-gui=no"

	econf --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc/${PN} \
		--libdir=/usr/$(get_libdir) \
		--enable-static \
		--enable-fdb \
		--enable-ltdllib \
		${myconf} || die "econf failed"
	emake -j1 || die "emake failed"

	if use gnome; then
		# Symlink for configure
		ln -s "${S}"/odbcinst/.libs ./lib
		# Symlink for libtool
		ln -s "${S}"/odbcinst/.libs ./lib/.libs

		cd gODBCConfig
		econf --host=${CHOST} \
			--with-odbc="${S}" \
			--enable-static \
			--prefix=/usr \
			--sysconfdir=/etc/${PN} || die "econf gODBCConfig failed"
		ln -s ../depcomp .
		ln -s ../libtool .

		emake || die "emake gODBCConfig failed"
		cd ..
	fi
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"

	if use gnome;
	then
		cd gODBCConfig
		emake DESTDIR="${D}" install || die "emake gODBCConfig install failed"
		cd ..
	fi

	dodoc AUTHORS ChangeLog NEWS README*
	find doc/ -name "Makefile*" -exec rm '{}' \;
	dohtml doc/*
	prepalldocs
}
