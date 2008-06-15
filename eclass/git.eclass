# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/git.eclass,v 1.12 2008/06/15 17:47:57 zlin Exp $

## --------------------------------------------------------------------------- #
# subversion.eclass author: Akinori Hattori <hattya@gentoo.org>
# modified for git by Donnie Berkholz <spyderous@gentoo.org>
# improved by Fernando J. Pereda <ferdy@gentoo.org>
#
# The git eclass is written to fetch the software sources from
# git repositories like the subversion eclass.
#
#
# Description:
#   If you use this eclass, the ${S} is ${WORKDIR}/${P}.
#   It is necessary to define the EGIT_REPO_URI variable at least.
#
## --------------------------------------------------------------------------- #

inherit eutils

EGIT="git.eclass"

EXPORT_FUNCTIONS src_unpack

HOMEPAGE="http://git.or.cz/"
DESCRIPTION="Based on the ${ECLASS} eclass"


## -- add git in DEPEND
#
DEPEND=">=dev-util/git-1.5"


## -- EGIT_STORE_DIR:  git sources store directory
#
EGIT_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/git-src"


## -- EGIT_FETCH_CMD:  git clone command
#
EGIT_FETCH_CMD="git clone --bare"

## -- EGIT_UPDATE_CMD:  git fetch command
#
EGIT_UPDATE_CMD="git fetch -f -u"

## -- EGIT_DIFFSTAT_CMD: Command to get diffstat output
#
EGIT_DIFFSTAT_CMD="git diff --stat"


## -- EGIT_OPTIONS:
#
# the options passed to clone and fetch
#
: ${EGIT_OPTIONS:=}


## -- EGIT_REPO_URI:  repository uri
#
# e.g. http://foo, git://bar
#
# supported protocols:
#   http://
#   https://
#   git://
#   git+ssh://
#   rsync://
#   ssh://
#
: ${EGIT_REPO_URI:=}


## -- EGIT_PROJECT:  project name of your ebuild
#
# git eclass will check out the git repository like:
#
#   ${EGIT_STORE_DIR}/${EGIT_PROJECT}/${EGIT_REPO_URI##*/}
#
# so if you define EGIT_REPO_URI as http://git.collab.net/repo/git or
# http://git.collab.net/repo/git. and PN is subversion-git.
# it will check out like:
#
#   ${EGIT_STORE_DIR}/subversion
#
# default: ${PN/-git}.
#
: ${EGIT_PROJECT:=${PN/-git}}


## -- EGIT_BOOTSTRAP:
#
# bootstrap script or command like autogen.sh or etc..
#
: ${EGIT_BOOTSTRAP:=}

# @ECLASS-VARIABLE: EGIT_OFFLINE
# @DESCRIPTION:
# Set this variable to a non-empty value to disable the automatic updating of
# an GIT source tree. This is intended to be set outside the git source
# tree by users.
EGIT_OFFLINE="${EGIT_OFFLINE:-${ESCM_OFFLINE}}"

## -- EGIT_PATCHES:
#
# git eclass can apply pathces in git_bootstrap().
# you can use regexp in this valiable like *.diff or *.patch or etc.
# NOTE: this patches will apply before eval EGIT_BOOTSTRAP.
#
# the process of applying the patch is:
#   1. just epatch it, if the patch exists in the path.
#   2. scan it under FILESDIR and epatch it, if the patch exists in FILESDIR.
#   3. die.
#
: ${EGIT_PATCHES:=}


## -- EGIT_BRANCH:
#
# git eclass can fetch any branch in git_fetch().
# If set, it must be before 'inherit git', otherwise both EGIT_BRANCH and
# EGIT_TREE must be set after 'inherit git'.
# Defaults to 'master'
#
: ${EGIT_BRANCH:=master}


## -- EGIT_TREE:
#
# git eclass can checkout any tree.
# Defaults to EGIT_BRANCH.
#
: ${EGIT_TREE:=${EGIT_BRANCH}}


## - EGIT_REPACK:
#
# git eclass will repack objects to save disk space. However this can take a
# long time with VERY big repositories. If this is your case set:
# EGIT_REPACK=false
#
: ${EGIT_REPACK:=false}

## - EGIT_PRUNE:
#
# git eclass can prune the local clone. This is useful if upstream rewinds and
# rebases branches too often. If you don't want this to happen, set:
# EGIT_PRUNE=false
#
: ${EGIT_PRUNE:=false}


## -- git_fetch() ------------------------------------------------- #

git_fetch() {

	local EGIT_CLONE_DIR

	# EGIT_REPO_URI is empty.
	[[ -z ${EGIT_REPO_URI} ]] && die "${EGIT}: EGIT_REPO_URI is empty."

	# check for the protocol or pull from a local repo.
	if [[ -z ${EGIT_REPO_URI%%:*} ]] ; then
		case ${EGIT_REPO_URI%%:*} in
			git*|http|https|rsync|ssh)
				;;
			*)
				die "${EGIT}: fetch from "${EGIT_REPO_URI%:*}" is not yet implemented."
				;;
		esac
	fi

	if [[ ! -d ${EGIT_STORE_DIR} ]] ; then
		debug-print "${FUNCNAME}: initial clone. creating git directory"
		addwrite /
		mkdir -p "${EGIT_STORE_DIR}" \
			|| die "${EGIT}: can't mkdir ${EGIT_STORE_DIR}."
		export SANDBOX_WRITE="${SANDBOX_WRITE%%:/}"
	fi

	cd -P "${EGIT_STORE_DIR}" || die "${EGIT}: can't chdir to ${EGIT_STORE_DIR}"
	EGIT_STORE_DIR=${PWD}

	# every time
	addwrite "${EGIT_STORE_DIR}"

	[[ -z ${EGIT_REPO_URI##*/} ]] && EGIT_REPO_URI="${EGIT_REPO_URI%/}"
	EGIT_CLONE_DIR="${EGIT_PROJECT}"

	debug-print "${FUNCNAME}: EGIT_OPTIONS = \"${EGIT_OPTIONS}\""

	export GIT_DIR="${EGIT_STORE_DIR}/${EGIT_CLONE_DIR}"

	if [[ ! -d ${EGIT_CLONE_DIR} ]] ; then
		# first clone
		einfo "git clone start -->"
		einfo "   repository: ${EGIT_REPO_URI}"

		${EGIT_FETCH_CMD} ${EGIT_OPTIONS} "${EGIT_REPO_URI}" ${EGIT_PROJECT} \
			|| die "${EGIT}: can't fetch from ${EGIT_REPO_URI}."

		# We use --bare cloning, so git doesn't do this for us.
		git config remote.origin.url "${EGIT_REPO_URI}"
	elif [[ -n ${EGIT_OFFLINE} ]] ; then
		local oldsha1=$(git rev-parse ${EGIT_BRANCH})
		einfo "git update offline mode -->"
		einfo "   repository: ${EGIT_REPO_URI}"
		einfo "   commit: ${oldsha1}"
	else
		# Git urls might change, so unconditionally set it here
		git config remote.origin.url "${EGIT_REPO_URI}"

		# fetch updates
		einfo "git update start -->"
		einfo "   repository: ${EGIT_REPO_URI}"

		local oldsha1=$(git rev-parse ${EGIT_BRANCH})

		${EGIT_UPDATE_CMD} ${EGIT_OPTIONS} origin ${EGIT_BRANCH}:${EGIT_BRANCH} \
			|| die "${EGIT}: can't update from ${EGIT_REPO_URI}."

		# piping through cat is needed to avoid a stupid Git feature
		${EGIT_DIFFSTAT_CMD} ${oldsha1}..${EGIT_BRANCH} | cat
	fi

	einfo "   local clone: ${EGIT_STORE_DIR}/${EGIT_CLONE_DIR}"

	if ${EGIT_REPACK} || ${EGIT_PRUNE} ; then
		ebegin "Garbage collecting the repository"
		git gc $(${EGIT_PRUNE} && echo '--prune')
		eend $?
	fi

	einfo "   committish: ${EGIT_TREE}"

	# export to the ${WORKDIR}
	mkdir -p "${S}"
	git archive --format=tar ${EGIT_TREE} | ( cd "${S}" ; tar xf - )

	echo ">>> Unpacked to ${S}"

}


## -- git_bootstrap() ------------------------------------------------ #

git_bootstrap() {

	local patch lpatch

	cd "${S}"

	if [[ -n ${EGIT_PATCHES} ]] ; then
		einfo "apply patches -->"

		for patch in ${EGIT_PATCHES} ; do
			if [[ -f ${patch} ]] ; then
				epatch ${patch}
			else
				for lpatch in "${FILESDIR}"/${patch} ; do
					if [[ -f ${lpatch} ]] ; then
						epatch ${lpatch}
					else
						die "${EGIT}: ${patch} is not found"
					fi
				done
			fi
		done
		echo
	fi

	if [[ -n ${EGIT_BOOTSTRAP} ]] ; then
		einfo "begin bootstrap -->"

		if [[ -f ${EGIT_BOOTSTRAP} ]] && [[ -x ${EGIT_BOOTSTRAP} ]] ; then
			einfo "   bootstrap with a file: ${EGIT_BOOTSTRAP}"
			eval "./${EGIT_BOOTSTRAP}" \
				|| die "${EGIT}: can't execute EGIT_BOOTSTRAP."
		else
			einfo "   bootstrap with commands: ${EGIT_BOOTSTRAP}"
			eval "${EGIT_BOOTSTRAP}" \
				|| die "${EGIT}: can't eval EGIT_BOOTSTRAP."
		fi
	fi

}


## -- git_src_unpack() ------------------------------------------------ #

git_src_unpack() {

	git_fetch     || die "${EGIT}: unknown problem in git_fetch()."
	git_bootstrap || die "${EGIT}: unknown problem in git_bootstrap()."

}
