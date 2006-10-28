# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/freebsd.eclass,v 1.10 2006/10/28 22:29:14 swegener Exp $
#
# Diego Pettenò <flameeyes@gentoo.org>

inherit versionator eutils flag-o-matic bsdmk

LICENSE="BSD"
HOMEPAGE="http://www.freebsd.org/"

# Define global package names
LIB="freebsd-lib-${PV}"
BIN="freebsd-bin-${PV}"
CONTRIB="freebsd-contrib-${PV}"
SHARE="freebsd-share-${PV}"
UBIN="freebsd-ubin-${PV}"
USBIN="freebsd-usbin-${PV}"
CRYPTO="freebsd-crypto-${PV}"
LIBEXEC="freebsd-libexec-${PV}"
SBIN="freebsd-sbin-${PV}"
GNU="freebsd-gnu-${PV}"
ETC="freebsd-etc-${PV}"
SYS="freebsd-sys-${PV}"
INCLUDE="freebsd-include-${PV}"
RESCUE="freebsd-rescue-${PV}"

# Release version (5.3, 5.4, 6.0, etc)
RV="$(get_version_component_range 1-2)"

if [[ ${PN} != "freebsd-share" ]] && [[ ${PN} != freebsd-sources ]]; then
	IUSE="profile"
fi

#unalias -a
alias install-info='/usr/bin/bsdinstall-info'

EXPORT_FUNCTIONS src_compile src_install src_unpack

# doperiodic <kind> <file> ...
doperiodic() {
	local kind=$1
	shift

	INSDESTTREE="/etc/periodic/${kind}"
	INSOPTIONS="-m 0755" \
	doins "$@"
}

freebsd_get_bmake() {
	local bmake
	bmake=$(get_bmake)
	[[ ${CBUILD} == *-freebsd* ]] || bmake="${bmake} -m /usr/share/mk/freebsd"

	echo ${bmake}
}

freebsd_src_unpack() {
	unpack ${A}
	cd ${S}

	for patch in ${PATCHES}; do
		epatch ${patch}
	done

	dummy_mk ${REMOVE_SUBDIRS}

	ebegin "Renaming libraries"
	# We don't use libtermcap, we use libncurses
	find ${S} -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-ltermcap:-lncurses:g; s:{LIBTERMCAP}:{LIBNCURSES}:g'
	# flex provides libfl, not libl
	find ${S} -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-ll:-lfl:g; s:{LIBL}:{LIBFL}:g'

	eend $?
}

freebsd_src_compile() {
	use profile && filter-flags "-fomit-frame-pointer"
	use profile || \
		case "${RV}" in
			5.*) mymakeopts="${mymakeopts} NOPROFILE= " ;;
			6.*) mymakeopts="${mymakeopts} NO_PROFILE= " ;;
		esac

	mymakeopts="${mymakeopts} NO_MANCOMPRESS= NO_INFOCOMPRESS="

	# Many things breaks when using ricer flags here
	[[ -z ${NOFLAGSTRIP} ]] && strip-flags

	# Make sure to use FreeBSD definitions while crosscompiling
	[[ -z ${BMAKE} ]] && BMAKE="$(freebsd_get_bmake)"

	bsdmk_src_compile
}

freebsd_src_install() {
	use profile || \
		case "${RV}" in
			5.*) mymakeopts="${mymakeopts} NOPROFILE= " ;;
			6.*) mymakeopts="${mymakeopts} NO_PROFILE= " ;;
		esac

	mymakeopts="${mymakeopts} NO_MANCOMPRESS= NO_INFOCOMPRESS="

	[[ -z ${BMAKE} ]] && BMAKE="$(freebsd_get_bmake)"

	bsdmk_src_install
}
