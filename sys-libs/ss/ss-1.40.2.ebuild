# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/ss/ss-1.40.2.ebuild,v 1.5 2007/11/19 07:39:26 kumba Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Subsystem command parsing library"
HOMEPAGE="http://e2fsprogs.sourceforge.net/"
SRC_URI="mirror://sourceforge/e2fsprogs/e2fsprogs-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~m68k mips ~ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="nls"

RDEPEND="~sys-libs/com_err-${PV}"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/e2fsprogs-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.39-makefile.patch
}

src_compile() {
	export LDCONFIG=/bin/true
	export CC=$(tc-getCC)
	export STRIP=/bin/true

	# We want to use the "bsd" libraries while building on Darwin, but while
	# building on other Gentoo/*BSD we prefer elf-naming scheme.
	local libtype
	case ${CHOST} in
		*-darwin*) libtype=bsd;;
		*)         libtype=elf;;
	esac

	econf \
		--enable-${libtype}-shlibs \
		--with-ldopts="${LDFLAGS}" \
		$(use_enable nls) \
		|| die
	emake -C lib/ss COMPILE_ET=compile_et || die "make ss failed"
}

src_test() {
	make -C lib/ss check || die "make check failed"
}

src_install() {
	export LDCONFIG=/bin/true
	export CC=$(tc-getCC)
	export STRIP=/bin/true

	dodir /usr/share/man/man1
	make -C lib/ss DESTDIR="${D}" install || die

	# Move shared libraries to /lib/, install static libraries to /usr/lib/,
	# and install linker scripts to /usr/lib/.
	dodir /$(get_libdir)
	mv "${D}"/usr/$(get_libdir)/*.so* "${D}"/$(get_libdir)/ || die "move .so"
	dolib.a lib/libss.a || die "dolib.a"
	gen_usr_ldscript libss.so
}
