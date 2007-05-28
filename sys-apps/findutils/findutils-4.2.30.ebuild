# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/findutils/findutils-4.2.30.ebuild,v 1.2 2007/05/28 04:57:49 jer Exp $

inherit eutils flag-o-matic toolchain-funcs

SELINUX_PATCH="findutils-4.2.24-selinux.diff"

DESCRIPTION="GNU utilities for finding files"
HOMEPAGE="http://www.gnu.org/software/findutils/findutils.html"
# SRC_URI="mirror://gnu/${PN}/${P}.tar.gz mirror://gentoo/${P}.tar.gz"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="nls build selinux static"

RDEPEND="selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Don't build or install locate because it conflicts with slocate,
	# which is a secure version of locate.  See bug 18729
	sed -i '/^SUBDIRS/s/locate//' Makefile.in

	# Patches for selinux
	use selinux && epatch "${FILESDIR}/${SELINUX_PATCH}"

	if [[ ${ELIBC} == "glibc" || ${ELIBC} == "uclibc" ]]; then
		# Use the system-provided regex.h, bug #114747
		echo "#include_next <regex.h>" > gnulib/lib/regex.h
	fi
}

src_compile() {
	use static && append-ldflags -static

	local myconf
	use userland_GNU || myconf=" --program-prefix=g"

	[[ ${ELIBC} == "glibc" || ${ELIBC} == "uclibc" ]] && \
		myconf="${myconf} --without-included-regex"

	econf $(use_enable nls) ${myconf} || die "configure failed"
	emake libexecdir=/usr/lib/find AR="$(tc-getAR)" || die "make failed"
}

src_install() {
	make DESTDIR="${D}" libexecdir="${D}/usr/lib/find" install || die

	rm -rf "${D}"/usr/var
	use build \
		&& rm -rf "${D}"/usr/share \
		|| dodoc NEWS README TODO ChangeLog
}

pkg_postinst() {
	ewarn "Please note that the locate and updatedb binaries"
	ewarn "are now provided by slocate, not findutils."
}
