# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/ghdl/ghdl-0.27.ebuild,v 1.1 2009/06/06 17:07:53 calchan Exp $

EAPI="2"

inherit multilib

GCC_VERSION="4.2.4"

DESCRIPTION="Complete VHDL simulator using the GCC technology"
HOMEPAGE="http://ghdl.free.fr"
SRC_URI="http://ghdl.free.fr/${P}.tar.bz2
	mirror://gnu/gcc/releases/gcc-${GCC_VERSION}/gcc-core-${GCC_VERSION}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND=">=sys-apps/portage-2.1.2.10
	>=dev-lang/gnat-gcc-4.2"
RDEPEND=""
S="${WORKDIR}/gcc-${GCC_VERSION}"

src_prepare() {
	mv "${WORKDIR}/${P}"/vhdl gcc
	sed -i -e 's/ADAC = \$(CC)/ADAC = gnatgcc/' gcc/vhdl/Makefile.in || die "sed failed"
	sed -i -e 's/AGCC_CFLAGS=-g/AGCC_CFLAGS=$(CFLAGS)/' gcc/vhdl/Make-lang.in || die "sed failed"

	# Fix issue similar to bug #195074, ported from vapier's fix for binutils
	sed -i -e "s:egrep.*texinfo.*dev/null:egrep 'texinfo[^0-9]*(4\.([4-9]|[1-9][0-9])|[5-9]|[1-9][0-9])' >/dev/null:" \
		configure* || die "sed failed"

	# For multilib profile arch, see bug #203721
	if (has_multilib_profile || use multilib ) ; then
		for T_LINUX64 in `find "${S}/gcc/config" -name t-linux64` ;
		do
			einfo "sed for ${T_LINUX64} for multilib. :)"
			sed -i \
				-e "s:\(MULTILIB_OSDIRNAMES = \).*:\1../lib64 ../lib32:" \
				"${T_LINUX64}" \
			|| die "sed for ${T_LINUX64} failed. :("
		done
	fi
}

src_configure() {
	econf --enable-languages=vhdl
}

src_compile() {
	emake -j1 || die "Compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"

	cd "${D}"/usr/bin ; rm `ls --ignore=ghdl`
	rm -rf "${D}"/usr/include
	rm "${D}"/usr/$(get_libdir)/lib*
	cd "${D}"/usr/$(get_libdir)/gcc/${CHOST}/${GCC_VERSION} ; rm -rf `ls --ignore=vhdl*`
	cd "${D}"/usr/libexec/gcc/${CHOST}/${GCC_VERSION} ; rm -rf `ls --ignore=ghdl*`
	cd "${D}"/usr/share/info ; rm `ls --ignore=ghdl*`
	cd "${D}"/usr/share/man/man1 ; rm `ls --ignore=ghdl*`
	rm -Rf "${D}"/usr/share/locale
	rm -Rf "${D}"/usr/share/man/man7
}
