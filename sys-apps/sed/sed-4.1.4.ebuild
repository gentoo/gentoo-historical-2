# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sed/sed-4.1.4.ebuild,v 1.1 2005/02/19 18:26:28 vapier Exp $

inherit flag-o-matic

DESCRIPTION="Super-useful stream editor"
HOMEPAGE="http://sed.sourceforge.net/"
SRC_URI="mirror://gnu/sed/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~arm ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~ppc-macos ~s390 ~sh ~sparc ~x86"
IUSE="nls static build bootstrap"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_bootstrap_sed() {
	# make sure system-sed works #40786
	export NO_SYS_SED=""
	if ! use bootstrap && ! use build ; then
		if ! type -p sed ; then
			NO_SYS_SED="!!!"
			./bootstrap.sh || die "couldnt bootstrap"
			cp sed/sed ${T}/ || die "couldnt copy"
			export PATH="${PATH}:${T}"
		fi
	fi
}
src_bootstrap_cleanup() {
	if [[ -n ${NO_SYS_SED} ]] ; then
		make clean || die "couldnt clean"
	fi
}

src_compile() {
	src_bootstrap_sed

	local myconf=""
	use ppc-macos && myconf="--program-prefix=g"
	econf \
		$(use_enable nls) \
		${myconf} \
		|| die "Configure failed"

	src_bootstrap_sed
	use static && append-ldflags -static
	emake LDFLAGS="${LDFLAGS}" || die "build failed"
}

src_install() {
	into /
	dobin sed/sed || die "dobin"
	if ! use build ; then
		make install DESTDIR="${D}" || die "Install failed"
		dodoc NEWS README* THANKS AUTHORS BUGS ChangeLog
		docinto examples
		dodoc "${FILESDIR}/dos2unix" "${FILESDIR}/unix2dos"
	else
		dodir /usr/bin
	fi

	rm -f "${D}"/usr/bin/sed
	if use ppc-macos ; then
		cd "${D}"
		local x
		for x in $(find . -name 'sed*' -print) ; do
			mv "$x" "${x//sed/gsed}"
		done
		dosym /bin/gsed /usr/bin/gsed
	else
		dosym /bin/sed /usr/bin/sed
	fi
}
