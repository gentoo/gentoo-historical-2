# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrtools/cdrtools-2.01.01_alpha67.ebuild,v 1.1 2009/11/04 18:17:23 billie Exp $

EAPI=2

inherit multilib eutils toolchain-funcs flag-o-matic

DESCRIPTION="A set of tools for CD/DVD reading and recording, including cdrecord"
HOMEPAGE="http://cdrecord.berlios.de/"
SRC_URI="ftp://ftp.berlios.de/pub/cdrecord/alpha/${P/_alpha/a}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1 CDDL-Schily"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="unicode acl"

DEPEND="acl? ( sys-apps/acl )
	!app-cdr/dvdrtools
	!app-cdr/cdrkit"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-2.01.01

src_prepare() {
	# Adjusting hardcoded paths.
	sed -i -e 's:opt/schily:usr:' \
		$(grep -l --include='*.1' --include='*.8' -r 'opt/schily' .) \
		$(grep -l --include='*.c' --include='*.h' -r 'opt/schily' .) \
		|| die "404 on opt-schily sed"

	sed -i -e "s:\(^INSDIR=\t\tshare/doc/\):\1${PF}/:" \
		$(grep -l -r 'INSDIR.\+doc' .) \
		|| die "404 on doc sed"

	# Respect libdir.
	sed -i -e "s:\(^INSDIR=\t\t\)lib:\1$(get_libdir):" \
		$(grep -l -r '^INSDIR.\+lib\(/siconv\)\?$' .) \
		|| die "404 on multilib-sed"

	# See previous comment s/libdir/--disable-static/.
	sed -i -e 's:include\t\t.*rules.lib::' \
		$(grep -l -r '^include.\+rules\.lib' .) \
		|| die "404 on rules sed"

	# Remove profiled make files.
	rm -f $(find . -name '*_p.mk') || die "rm failed"

	epatch "${FILESDIR}"/${PN}-2.01.01_alpha50-asneeded.patch

	# Schily make setup.
	cd "${S}"/DEFAULTS
	local MYARCH="linux"

	sed -i "s:/opt/schily:/usr:g" Defaults.${MYARCH} || die "sed schily-opt failed"
	sed -i "s:/usr/src/linux/include::g" Defaults.${MYARCH} || die "sed linux-include failed"
	sed -i "/RUNPATH/ c\RUNPATH= " Defaults.${MYARCH} || die "sed RUNPATH failed"

	cd "${S}"/RULES

	# Respect CC/CXX variables
	local tcCC=$(tc-getCC)
	local tcCXX=$(tc-getCXX)
	sed -i -e "/cc-config.sh/s/\$(C_ARCH:%64=%) \$(CCOM_DEF)/${tcCC} ${tcCC}/" \
		rules1.top || die "sed rules1.top failed"
	sed -i -e "/^\(CC\|DYNLD\|LDCC\|MKDEP\)/s/gcc/${tcCC}/" \
		-e "/^\(CC++\|DYNLDC++\|LDCC++\|MKC++DEP\)/s/g++/${tcCXX}/" \
		cc-gcc.rul || die "sed cc-gcc.rul failed"
	sed -i -e "s/^#CONFFLAGS +=\t-cc=\$(XCC_COM)$/CONFFLAGS +=\t-cc=${tcCC}/g" \
		rules.cnf || die "sed rules.cnf failed"

	# Create additional symlinks needed for some archs.
	local t
	for t in ppc64 sh4 s390x ; do
		ln -s i586-linux-cc.rul ${t}-linux-cc.rul || die
		ln -s i586-linux-gcc.rul ${t}-linux-gcc.rul || die
	done
}

src_configure() { : ; }

src_compile() {
	local ACL="-lacl"
	if use unicode; then
		local flags="$(test-flags -finput-charset=ISO-8859-1 -fexec-charset=UTF-8)"
		if [[ -n ${flags} ]]; then
			append-flags ${flags}
		else
			ewarn "Your compiler does not support the options required to build"
			ewarn "cdrtools with unicode in USE. unicode flag will be ignored."
		fi
	fi

	if ! use acl
	then
		CFLAGS="${CFLAGS} -DNO_ACL"
		ACL=""
	fi
	# If not built with -j1, "sometimes" cdda2wav will not be built. Bug?
	emake -j1 CC="$(tc-getCC) -D__attribute_const__=const" COPTX="${CFLAGS}" \
		LIB_ACL_TEST="${ACL}" CPPOPTX="${CPPFLAGS}" LDOPTX="${LDFLAGS}" \
		GMAKE_NOWARN="true" || die "emake failed"
}

src_install() {
	# If not built with -j1, "sometimes" manpages are not installed. Bug?
	emake -j1 MANDIR="share/man" INS_BASE="${D}/usr/" INS_RBASE="${D}" \
		LINKMODE="dynamic" GMAKE_NOWARN="true" install

	# These symlinks are for compat with cdrkit.
	dosym schily /usr/include/scsilib
	dosym ../scg /usr/include/schily/scg

	dodoc ABOUT Changelog README README.linux-shm START READMEs/README.linux || die "dodoc cdrtools"

	cd "${S}"/cdda2wav
	docinto cdda2wav
	dodoc FAQ Frontends HOWTOUSE TODO || die "dodoc cdda2wav"
}
