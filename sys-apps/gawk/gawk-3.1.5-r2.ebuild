# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gawk/gawk-3.1.5-r2.ebuild,v 1.8 2006/08/10 10:27:02 nigoro Exp $

inherit eutils toolchain-funcs multilib

DESCRIPTION="GNU awk pattern-matching language"
HOMEPAGE="http://www.gnu.org/software/gawk/gawk.html"
SRC_URI="mirror://gnu/gawk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~m68k ~mips ppc ~ppc-macos ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="nls build"

RDEPEND=""
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

SFFS=${WORKDIR}/filefuncs

src_unpack() {
	unpack ${P}.tar.gz

	# Copy filefuncs module's source over ...
	cp -r "${FILESDIR}"/filefuncs "${SFFS}" || die "cp failed"

	cd "${S}"
	epatch "${FILESDIR}"/${P}-core.patch
	epatch "${FILESDIR}"/${P}-gcc4.patch
	epatch "${FILESDIR}"/${P}-utf-8-strcat.patch
	epatch "${FILESDIR}"/${P}-autotools-crap.patch #139397
	# Patches from Fedora
	epatch "${FILESDIR}"/${PN}-3.1.3-getpgrp_void.patch
	epatch "${FILESDIR}"/${P}-fieldwidths.patch #127163
	epatch "${FILESDIR}"/${P}-binmode.patch
	epatch "${FILESDIR}"/${P}-num2str.patch
	epatch "${FILESDIR}"/${P}-internal.patch
	epatch "${FILESDIR}"/${P}-numflags.patch
	epatch "${FILESDIR}"/${P}-syntaxerror.patch
	# support for dec compiler.
	[[ $(tc-getCC) == "ccc" ]] && epatch "${FILESDIR}"/${PN}-3.1.2-dec-alpha-compiler.diff
}

src_compile() {
	econf \
		--bindir=/bin \
		--libexec='$(libdir)/misc' \
		$(use_enable nls) \
		--enable-switch \
		|| die
	emake || die "emake failed"

	cd "${SFFS}"
	emake CC=$(tc-getCC) || die "filefuncs emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "install failed"
	cd "${SFFS}"
	make LIBDIR="$(get_libdir)" install || die "filefuncs install failed"

	dodir /usr/bin
	# In some rare cases, (p)gawk gets installed as (p)gawk- and not
	# (p)gawk-${PV} ...  Also make sure that /bin/(p)gawk is a symlink
	# to /bin/(p)gawk-${PV}.
	local binpath x
	for x in gawk pgawk igawk ; do
		[[ ${x} == "gawk" ]] \
			&& binpath="/bin" \
			|| binpath="/usr/bin"

		if [[ -f ${D}/bin/${x} && ! -f ${D}/bin/${x}-${PV} ]] ; then
			mv -f "${D}"/bin/${x} "${D}"/${binpath}/${x}-${PV}
		elif [[ -f ${D}/bin/${x}- && ! -f ${D}/bin/${x}-${PV} ]] ; then
			mv -f "${D}"/bin/${x}- "${D}"/${binpath}/${x}-${PV}
		elif [[ ${binpath} == "/usr/bin" && -f ${D}/bin/${x}-${PV} ]] ; then
			mv -f "${D}"/bin/${x}-${PV} "${D}"/${binpath}/${x}-${PV}
		fi

		rm -f "${D}"/bin/${x}
		dosym ${x}-${PV} ${binpath}/${x}
		[[ ${binpath} == "/usr/bin" ]] && dosym /usr/bin/${x}-${PV} /bin/${x}
	done

	rm -f "${D}"/bin/awk
	dodir /usr/bin
	# Compat symlinks
	dosym /bin/gawk-${PV} /usr/bin/gawk
	dosym gawk-${PV} /bin/awk
	dosym /bin/gawk-${PV} /usr/bin/awk
	[[ ${USERLAND} != "GNU" ]] && rm -f "${D}"/{,usr/}bin/awk{,-${PV}}

	# Install headers
	insinto /usr/include/awk
	doins "${S}"/*.h || die "ins headers failed"
	# We do not want 'acconfig.h' in there ...
	rm -f "${D}"/usr/include/awk/acconfig.h

	if ! use build ; then
		cd "${S}"
		rm -f "${D}"/usr/share/man/man1/pgawk.1
		dosym gawk.1.gz /usr/share/man/man1/pgawk.1.gz
		[[ ${USERLAND} == "GNU" ]] && dosym gawk.1.gz /usr/share/man/man1/awk.1.gz
		dodoc AUTHORS ChangeLog FUTURES LIMITATIONS NEWS PROBLEMS POSIX.STD README
		docinto README_d
		dodoc README_d/*
		docinto awklib
		dodoc awklib/ChangeLog
		docinto pc
		dodoc pc/ChangeLog
		docinto posix
		dodoc posix/ChangeLog
	else
		rm -r "${D}"/usr/share
	fi
}
