# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sed/sed-4.0.9.ebuild,v 1.25 2004/10/03 08:58:00 vapier Exp $

inherit gnuconfig flag-o-matic

DESCRIPTION="Super-useful stream editor"
HOMEPAGE="http://sed.sourceforge.net/"
SRC_URI="mirror://gnu/sed/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha arm amd64 hppa ia64 macos mips ppc ppc64 ppc-macos s390 sparc x86"
IUSE="nls static build"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S}
	gnuconfig_update
}

src_compile() {
	# make sure system-sed works #40786
	export NO_SYS_SED=""
	if ! which sed >& /dev/null ; then
		NO_SYS_SED="!!!"
		./bootstrap.sh || die "couldnt bootstrap"
		cp sed/sed ${T}/ || die "couldnt copy"
		export PATH="${PATH}:${T}"
	fi

	local myconf=""
	if use macos || use ppc-macos ; then
		myconf="--program-prefix=g"
	fi
	econf \
		$(use_enable nls) \
		${myconf} \
		|| die "Configure failed"
	if [ ! -z "${NO_SYS_SED}" ] ; then 
		make clean || die "couldnt clean"
	fi

	use static && append-ldflags -static
	emake LDFLAGS="${LDFLAGS}" || die "build failed"
}

src_install() {
	[ ! -z "${NO_SYS_SED}" ] && export PATH="${PATH}:${T}"

	into /
	dobin sed/sed || die "dobin"
	if ! use build
	then
		einstall || die "Install failed"
		dodoc NEWS README* THANKS AUTHORS BUGS ChangeLog
		docinto examples
		dodoc "${FILESDIR}/dos2unix" "${FILESDIR}/unix2dos"
	else
		dodir /usr/bin
	fi

	rm -f "${D}/usr/bin/sed"
	if use macos || use ppc-macos ; then
		cd "${D}"
		local x
		for x in $(find . -name 'sed*' -print);
		do
			mv "$x" "${x//sed/gsed}"
		done
		dosym ../../bin/gsed /usr/bin/gsed
	else
		dosym ../../bin/sed /usr/bin/sed
	fi
}
