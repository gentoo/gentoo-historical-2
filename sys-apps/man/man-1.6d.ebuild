# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/man/man-1.6d.ebuild,v 1.7 2006/08/19 18:52:47 blubb Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Standard commands to read man pages"
HOMEPAGE="http://primates.ximian.com/~flucifredi/man/"
SRC_URI="http://primates.ximian.com/~flucifredi/man/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ia64 m68k ~mips ppc ppc64 s390 sh ~sparc x86 ~x86-fbsd"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"
DEPEND=">=sys-apps/groff-1.18
	!sys-apps/man-db"
PROVIDE="virtual/man"

pkg_setup() {
	enewgroup man 15
	enewuser man 13 -1 /usr/share/man man
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# We love to cross-compile
	epatch "${FILESDIR}"/man-1.6-cross-compile.patch

	# Fix search order in man.conf so that system installed manpages
	# will be found first ...
	epatch "${FILESDIR}"/man-1.5p-search-order.patch

	# For groff-1.18 or later we need to call nroff with '-c'
	epatch "${FILESDIR}"/man-1.5m-groff-1.18.patch

	# makewhatis traverses manpages twice, as default manpath
	# contains two directories that are symlinked together
	epatch "${FILESDIR}"/man-1.5p-defmanpath-symlinks.patch

	# makewhatis should get section info from config, not hardcode it #86863
	epatch "${FILESDIR}"/man-1.6a-makewhatis-config.patch

	# add more sections to default search path
	epatch "${FILESDIR}"/man-1.6b-more-sections.patch

	# cut out symlinked paths #90186
	epatch "${FILESDIR}"/man-1.6c-cut-duplicate-manpaths.patch

	# Fedora patches
	epatch "${FILESDIR}"/man-1.5m2-apropos.patch

	# include more headers
	epatch "${FILESDIR}"/man-1.6d-headers.patch

	# use non-lazy binds for man
	epatch "${FILESDIR}"/man-1.6b-build.patch

	# Fixes compilation in FreeBSD wrt #138123
	epatch "${FILESDIR}"/man-1.6d-fbsd.patch

	strip-linguas $(eval $(grep ^LANGUAGES= configure) ; echo ${LANGUAGES//,/ })
}

src_compile() {
	tc-export CC BUILD_CC

	local mylang=
	if use nls ; then
		if [[ -z ${LINGUAS} ]] ; then
			mylang="all"
		else
			mylang="${LINGUAS// /,}"
		fi
	else
		mylang="none"
	fi
	./configure \
		-confdir=/etc \
		+sgid +fhs \
		+lang ${mylang} \
		|| die "configure failed"

	export BINDNOW_FLAGS=$(bindnow-flags)
	emake || die "emake failed"
}

src_install() {
	make PREFIX="${D}" install || die "make install failed"
	dosym man /usr/bin/manpath

	dodoc LSM README* TODO

	exeinto /etc/cron.weekly
	newexe "${FILESDIR}"/makewhatis.cron makewhatis

	keepdir /var/cache/man
	diropts -m0775 -g man
	local mansects=$(grep ^MANSECT "${D}"/etc/man.conf | cut -f2-)
	for x in ${mansects//:/ } ; do
		keepdir /var/cache/man/cat${x}
	done
}

pkg_postinst() {
	einfo "Forcing sane permissions onto ${ROOT}/var/cache/man (Bug #40322)"
	chown -R root:man "${ROOT}"/var/cache/man
	chmod -R g+w "${ROOT}"/var/cache/man
	[[ -e ${ROOT}/var/cache/man/whatis ]] \
		&& chown root:0 "${ROOT}"/var/cache/man/whatis

	echo

	local files=$(ls "${ROOT}"/etc/cron.{daily,weekly}/makewhatis{,.cron} 2>/dev/null)
	if [[ ${files/$'\n'} != ${files} ]] ; then
		ewarn "You have multiple makewhatis cron files installed."
		ewarn "You might want to delete all but one of these:"
		echo ${files}
	fi
}
